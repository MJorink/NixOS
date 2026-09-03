#!/usr/bin/env bash
# Script to build all my bonelab code mods at once, makes it easier to test them while developing.
# JLib first: every other mod references its staged DLL, so it cannot build in parallel with them.
# With "staging" as argument, also zip each mod's Staging/Thunderstore tree to ~/ModBuilds/Staging/<mod>.zip.
# With "push" as argument, also show diff, wait for confirmation, commit and push to repos.

quest=~/ModBuilds
pc=~/.steam/steam/steamapps/common/BONELAB/Mods
stage=""
[ "$1" = staging ] && stage=1
mkdir -p "$quest"
mods=(JLib Downed HealthRegenToggle NoVirtualCrouch QuestGraphicsSettings SprInput VitalShift)

build() {
	m=$1
	dotnet build "$HOME/repos/BONELAB/$m" > "/tmp/build-$m.log" 2>&1 &&
		cp "$HOME/repos/BONELAB/$m/Staging/Thunderstore/Mods/$m.dll" "$quest/" &&
		{ [ "$m" = QuestGraphicsSettings ] || cp "$HOME/repos/BONELAB/$m/Staging/Thunderstore/Mods/$m.dll" "$pc/"; } &&
		{ [ -z "$stage" ] || { mkdir -p "$quest/Staging" && rm -f "$quest/Staging/$m.zip" && (cd "$HOME/repos/BONELAB/$m/Staging/Thunderstore" && zip -qr "$quest/Staging/$m.zip" .); }; } &&
		echo "ok   $m" ||
		{ echo "FAIL $m (see /tmp/build-$m.log)"; return 1; }
}

build "${mods[0]}" || echo "warning: JLib failed, dependents may build against stale JLib.dll"

pids=()
for m in "${mods[@]:1}"; do
	build "$m" &
	pids+=($!)
done

fail=0
for p in "${pids[@]}"; do wait "$p" || fail=1; done

[ "$2" = push ] || exit $fail

dirty=()
for m in "${mods[@]}"; do
	git -C "$HOME/repos/BONELAB/$m" add -A
	git -C "$HOME/repos/BONELAB/$m" diff --cached --quiet && continue
	dirty+=("$m")
	echo "=== $m ==="
	git -C "$HOME/repos/BONELAB/$m" --no-pager diff --cached
done

[ ${#dirty[@]} -eq 0 ] && { echo "nothing to push"; exit $fail; }

read -r -p "Push ${#dirty[@]} mod(s) to origin main? [y/N] " ans
case "$ans" in
	[yY]*) ;;
	*) echo "cancelled"; exit $fail ;;
esac

for m in "${dirty[@]}"; do
	git -C "$HOME/repos/BONELAB/$m" commit -qm "Scripted Push" &&
		git -C "$HOME/repos/BONELAB/$m" push -q origin main &&
		echo "pushed $m" ||
		{ echo "FAIL push $m"; fail=1; }
done

exit $fail
