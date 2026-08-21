echo "This is how I install my setup from the installer iso,"
echo "because when I try to install my full system from the iso it won't work because I will be out of memory."
echo "This way you can do a base install first and then immediately rebuild to your actual setup once booted into the base install."
echo ""

echo "Remember to setup disko.nix and hardware.nix first!"
echo ""

echo "Install from live iso with:"
echo ' sudo nix --extra-experimental-features "nix-command flakes" run "github:nix-community/disko/latest#disko-install" -- --flake .#BaseInstall --disk main /dev/nvme0n1 '
echo "(Change /dev/nvme0n1 to your disk!)"
