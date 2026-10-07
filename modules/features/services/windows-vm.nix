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
      cores = 4;
      diskSize = "128G";
      qemu = "${pkgs.qemu_kvm}/bin";
      ovmf = "${pkgs.OVMF.fd}/FV";
      socat = "${pkgs.socat}/bin/socat";

      # Send a command to the QEMU monitor (cont/stop/system_powerdown)
      monitor = cmd: "echo ${cmd} | ${socat} - UNIX-CONNECT:${dir}/monitor.sock || true";

      # Resume the VM and correct the guest clock, which falls behind while paused
      resume = pkgs.writeShellScript "windows-vm-resume" ''
        ${monitor "cont"}
        echo "{\"execute\":\"guest-set-time\",\"arguments\":{\"time\":$(${pkgs.coreutils}/bin/date +%s%N)}}" \
          | ${pkgs.coreutils}/bin/timeout 5 ${socat} - UNIX-CONNECT:${dir}/qga.sock || true
      '';
      pause = pkgs.writeShellScript "windows-vm-pause" (monitor "stop");
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
        path = [ pkgs.e2fsprogs ];

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
            -machine q35,accel=kvm,hpet=off \
            -cpu host,hv-relaxed,hv-vapic,hv-spinlocks=0x1fff,hv-vpindex,hv-runtime,hv-time,hv-synic,hv-stimer,hv-stimer-direct,hv-reset,hv-frequencies,hv-tlbflush,hv-ipi \
            -global kvm-pit.lost_tick_policy=discard \
            -smp ${toString cores} \
            -m ${memory} \
            -rtc base=localtime \
            -drive if=pflash,format=raw,readonly=on,file=${ovmf}/OVMF_CODE.fd \
            -drive if=pflash,format=raw,file=OVMF_VARS.fd \
            -drive file=disk.qcow2,if=virtio,format=qcow2,cache=none,aio=native,discard=unmap \
            "''${installer[@]}" \
            -drive file=${pkgs.virtio-win.src},media=cdrom,readonly=on \
            -nic user,model=virtio-net-pci,hostfwd=tcp:127.0.0.1:13389-:3389 \
            -device virtio-serial \
            -chardev socket,path=qga.sock,server=on,wait=off,id=qga0 \
            -device virtserialport,chardev=qga0,name=org.qemu.guest_agent.0 \
            -vga std \
            -device qemu-xhci \
            -device usb-tablet \
            -vnc 127.0.0.1:0 \
            -monitor unix:monitor.sock,server,nowait
        '';

        # Ask Windows to shut down cleanly (a paused VM ignores the power button), then wait for QEMU to exit
        preStop = ''
          ${monitor "cont"}
          ${monitor "system_powerdown"}
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

      # Pause the VM while nobody is connected over RDP: connecting to port 3389 starts a proxy
      # that resumes the VM, and the VM is paused again once the proxy has been idle for an hour
      systemd.sockets.windows-rdp = {
        description = "RDP to the Windows VM";
        wantedBy = [ "sockets.target" ];
        listenStreams = [ "3389" ];
      };

      systemd.services.windows-rdp = {
        description = "RDP proxy to the Windows VM";
        requires = [ "windows-vm.service" ];
        after = [ "windows-vm.service" ];
        serviceConfig = {
          User = "windows-vm";
          Group = "windows-vm";
          ExecStartPre = resume;
          ExecStart = "${config.systemd.package}/lib/systemd/systemd-socket-proxyd --exit-idle-time=60min 127.0.0.1:13389";
          ExecStopPost = pause;
        };
      };

      # Pause the VM after boot if nobody has connected yet
      systemd.timers.windows-vm-pause = {
        wantedBy = [ "windows-vm.service" ];
        partOf = [ "windows-vm.service" ];
        timerConfig.OnActiveSec = "60min";
      };
      systemd.services.windows-vm-pause = {
        description = "Pause the idle Windows VM";
        serviceConfig = {
          Type = "oneshot";
          User = "windows-vm";
          Group = "windows-vm";
        };
        script = ''
          if ! ${config.systemd.package}/bin/systemctl is-active --quiet windows-rdp.service; then
            ${pause}
          fi
        '';
      };

      # Only allow RDP over tailscale and from the home LAN
      networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 3389 ];
      networking.firewall.extraCommands = ''
        iptables -A nixos-fw -p tcp --dport 3389 -s 192.168.100.0/24 -j nixos-fw-accept
      '';
    };
}
