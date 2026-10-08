{ ... }: {
  flake.nixosModules.music =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      library = "/srv/music";
      downloads = "/srv/downloads/soulseek";

      # Must contain:
      # SLSKD_SLSK_USERNAME="username" (Soulseek)
      # SLSKD_SLSK_PASSWORD="password" (Soulseek)
      # SLSKD_USERNAME="username" (slskd web UI)
      # SLSKD_PASSWORD="password" (slskd web UI)
      # SLSKD_API_KEY=(16+ chars, used by Soularr) # openssl -- rand -hex 16
      # LIDARR__AUTH__APIKEY=(32 hex chars, used by Soularr) # openssl -- rand -hex 24
      secrets = "/persistent/secrets/music.env";

      mullvad = lib.optional config.services.mullvad-vpn.enable "mullvad-settings.service";

      slskd-api = pkgs.python3Packages.buildPythonPackage rec {
        pname = "slskd_api";
        version = "0.1.5";
        format = "wheel";
        src = pkgs.fetchurl {
          url = "https://files.pythonhosted.org/packages/py3/s/${pname}/${pname}-${version}-py3-none-any.whl";
          hash = "sha256-3gPCGgtfK2MW+NvycMaFkIW/VS6B7WAkqxkvUdRWpMA=";
        };
        dependencies = [ pkgs.python3Packages.requests ];
      };

      soularr-src = pkgs.fetchFromGitHub {
        owner = "mrusse";
        repo = "soularr";
        rev = "2037399aa57433f9032bbae09833439830d2b409";
        hash = "sha256-a/HufH1y5QOX0jJolz8oVXZvOlCzg41ab+S35ZsWhWk=";
      };

      soularr-python = pkgs.python3.withPackages (ps: [
        ps.music-tag
        ps.pyarr
        slskd-api
      ]);

      # Soularr expands $VARS itself, so the API keys come from the secrets file at runtime
      soularr-config = pkgs.writeTextDir "config.ini" ''
        [Lidarr]
        api_key = $LIDARR__AUTH__APIKEY
        host_url = http://127.0.0.1:8686
        download_dir = ${downloads}
        disable_sync = False

        [Slskd]
        api_key = $SLSKD_API_KEY
        host_url = http://127.0.0.1:5030
        url_base = /
        download_dir = ${downloads}
        delete_searches = False
        stalled_timeout = 3600
        remote_queue_timeout = 300

        [Release Settings]
        use_selected_lidarr_release = False
        use_most_common_tracknum = True
        allow_multi_disc = True
        accepted_countries = Europe,Japan,United Kingdom,United States,[Worldwide],Australia,Canada
        skip_region_check = False
        accepted_formats = CD,Digital Media,Vinyl

        [Search Settings]
        search_timeout = 5000
        maximum_peer_queue = 50
        minimum_peer_upload_speed = 0
        minimum_filename_match_ratio = 0.8
        minimum_search_interval = 5
        allowed_filetypes = flac 16/44.1,flac
        search_type = incrementing_page
        number_of_albums_to_grab = 10
        search_source = missing
        failed_import_denylist = True

        [Download Settings]
        download_filtering = True
        use_extension_whitelist = False
        rename_download_folders = True

        [Logging]
        level = INFO
        log_to_file = False
      '';
    in
    {
      users.groups.music = { };
      users.users.lidarr.extraGroups = [ "music" ];
      users.users.slskd.extraGroups = [ "music" ];

      # Streaming / download server (Subsonic API) on :4533
      services.navidrome = {
        enable = true;
        settings = {
          Address = "0.0.0.0";
          Port = 4533;
          MusicFolder = library;
          EnableInsightsCollector = false;
        };
      };

      # Music library manager on :8686, root folder is /srv/music
      services.lidarr = {
        enable = true;
        environmentFiles = [ secrets ];
      };
      systemd.services.lidarr.serviceConfig.UMask = "0002";

      # Soulseek client on :5030
      services.slskd = {
        enable = true;
        environmentFile = secrets;
        settings = {
          directories.downloads = downloads;
          shares.directories = [ library ];
        };
      };
      systemd.services.slskd.serviceConfig.UMask = "0002";

      # Searches Soulseek for albums Lidarr wants and hands the downloads back to Lidarr
      systemd.services.soularr = {
        description = "Soularr (Lidarr -> slskd bridge)";
        after = [
          "lidarr.service"
          "slskd.service"
        ];
        requires = [
          "lidarr.service"
          "slskd.service"
        ];
        serviceConfig = {
          Type = "oneshot";
          User = "slskd";
          Group = "music";
          UMask = "0002";
          EnvironmentFile = secrets;
          StateDirectory = "soularr";
          WorkingDirectory = downloads;
          ExecStart = "${soularr-python}/bin/python -u ${soularr-src}/soularr.py --config-dir ${soularr-config} --var-dir /var/lib/soularr --no-lock-file";
        };
      };
      systemd.timers.soularr = {
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnBootSec = "5min";
          OnUnitInactiveSec = "10min";
        };
      };

      # Don't go online before Mullvad's lockdown firewall is up
      systemd.services.slskd.after = mullvad;
      systemd.services.slskd.requires = mullvad;
      systemd.services.lidarr.after = mullvad;
      systemd.services.lidarr.requires = mullvad;
      systemd.services.navidrome.after = mullvad;
      systemd.services.navidrome.requires = mullvad;

      preservation.preserveAt."/persistent".directories = [
        "/var/lib/navidrome"
        "/var/lib/slskd"
        "/var/lib/soularr"
        {
          directory = "/var/lib/lidarr";
          user = "lidarr";
          group = "lidarr";
        }
        {
          directory = library;
          user = "lidarr";
          group = "music";
          mode = "2775";
        }
        {
          directory = downloads;
          user = "slskd";
          group = "music";
          mode = "2775";
        }
      ];

      # Web UIs and the Subsonic API are only reachable over tailscale
      networking.firewall.interfaces.tailscale0.allowedTCPPorts = [
        4533
        8686
        5030
      ];
    };
}
