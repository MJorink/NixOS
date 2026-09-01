#!/bin/bash
# Script to build all my bonelab code mods at once, makes it easier to test them while developing.
# JLib first: every other mod references its staged DLL, so it cannot build in parallel with them.
quest=~/ModBuilds
pc=~/.steam/steam/steamapps/common/BONELAB/Mods
mkdir -p "$quest"

build() {
	m=$1
	dotnet build "$HOME/repos/$m" > "/tmp/build-$m.log" 2>&1 &&
		cp "$HOME/repos/$m/Staging/Thunderstore/Mods/$m.dll" "$quest/" &&
		{ [ "$m" = QuestGraphicsSettings ] || cp "$HOME/repos/$m/Staging/Thunderstore/Mods/$m.dll" "$pc/"; } &&
		echo "ok   $m" ||
		{ echo "FAIL $m (see /tmp/build-$m.log)"; return 1; }
}

build JLib || echo "warning: JLib failed, dependents may build against stale JLib.dll"

pids=()
for m in Downed HealthRegenToggle NoVirtualCrouch QuestGraphicsSettings SprInput VitalShift; do
	build "$m" &
	pids+=($!)
done

fail=0
for p in "${pids[@]}"; do wait "$p" || fail=1; done
exit $fail
