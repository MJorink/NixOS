{ ... }: {
  flake.nixosModules.windows-vm =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      dir = "/var/lib/windows-vm";
      memory = "4G";
      cores = 2;
      diskSize = "128G";
      qemu = "${pkgs.qemu_kvm}/bin";
      ovmf = "${pkgs.OVMF.fd}/FV";
    in
    {
      users.users.windows-vm = {
        isSystemUser = true;
        group = "windows-vm";
        extraGroups = [ "kvm" ];
      };
      users.groups.windows-vm = { };

      preservation.preserveAt."/persistent".directories = [
        {
          directory = dir;
          user = "windows-vm";
          group = "windows-vm";
          mode = "0750";
        }
      ];

      systemd.services.windows-vm = {
        description = "Windows 10 IoT LTSC VM";
        wantedBy = [ "multi-user.target" ];
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
        path = [
          pkgs.socat
          pkgs.e2fsprogs
        ];

        preStart = ''
          # Disable btrfs copy-on-write before the disk image is created
          chattr +C . || true
          if [ ! -f disk.qcow2 ]; then
            ${qemu}/qemu-img create -f qcow2 disk.qcow2 ${diskSize}
          fi
          if [ ! -f OVMF_VARS.fd ]; then
            install -m 600 ${ovmf}/OVMF_VARS.fd OVMF_VARS.fd
          fi
        '';

        script = ''
          installer=()
          if [ -f install.iso ]; then
            installer=(-drive file=install.iso,media=cdrom,readonly=on)
          fi

          exec ${qemu}/qemu-system-x86_64 \
            -name windows \
            -machine q35,accel=kvm \
            -cpu host,hv_relaxed,hv_vapic,hv_spinlocks=0x1fff,hv_time \
            -smp ${toString cores} \
            -m ${memory} \
            -rtc base=localtime \
            -drive if=pflash,format=raw,readonly=on,file=${ovmf}/OVMF_CODE.fd \
            -drive if=pflash,format=raw,file=OVMF_VARS.fd \
            -drive file=disk.qcow2,if=virtio,format=qcow2,cache=none,aio=native,discard=unmap \
            "''${installer[@]}" \
            -drive file=${pkgs.virtio-win.src},media=cdrom,readonly=on \
            -nic user,model=virtio-net-pci,hostfwd=tcp::3389-:3389,hostfwd=udp::3389-:3389 \
            -vga std \
            -device qemu-xhci \
            -device usb-tablet \
            -vnc 127.0.0.1:0 \
            -monitor unix:monitor.sock,server,nowait
        '';

        # Ask Windows to shut down cleanly, then wait for QEMU to exit
        preStop = ''
          echo system_powerdown | socat - UNIX-CONNECT:monitor.sock || true
          while kill -0 "$MAINPID" 2>/dev/null; do sleep 1; done
        '';

        serviceConfig = {
          User = "windows-vm";
          Group = "windows-vm";
          WorkingDirectory = dir;
          Restart = "on-failure";
          TimeoutStopSec = 120;
        };
      };

      # Only allow RDP over tailscale and from the home LAN
      networking.firewall.interfaces.tailscale0 = {
        allowedTCPPorts = [ 3389 ];
        allowedUDPPorts = [ 3389 ];
      };
      networking.firewall.extraCommands = ''
        iptables -A nixos-fw -p tcp --dport 3389 -s 192.168.100.0/24 -j nixos-fw-accept
        iptables -A nixos-fw -p udp --dport 3389 -s 192.168.100.0/24 -j nixos-fw-accept
      '';
    };
}
