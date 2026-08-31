{ self, inputs, ... }: {
	perSystem = { lib, pkgs, ... }: {
		packages.myBtop = inputs.wrapper-modules.wrappers.btop.wrap {
			inherit pkgs;
			settings.color_theme = "noctalia";
			themes.noctalia = ''
				theme[main_bg]="#231d1b"
				theme[main_fg]="#e6dbd3"
				theme[title]="#b85a30"
				theme[hi_fg]="#d8a657"
				theme[selected_bg]="#453935"
				theme[selected_fg]="#e6dbd3"
				theme[inactive_fg]="#b8aca2"
				theme[proc_misc]="#8b9a5a"
				theme[cpu_box]="#76655f"
				theme[mem_box]="#76655f"
				theme[net_box]="#76655f"
				theme[proc_box]="#76655f"
				theme[div_line]="#4c413d"
				theme[temp_start]="#b85a30"
				theme[temp_mid]="#8b9a5a"
				theme[temp_end]="#d8a657"
				theme[cpu_start]="#b85a30"
				theme[cpu_mid]="#8b9a5a"
				theme[cpu_end]="#d8a657"
				theme[free_start]="#b85a30"
				theme[free_mid]="#8b9a5a"
				theme[free_end]="#d8a657"
				theme[cached_start]="#b85a30"
				theme[cached_mid]="#8b9a5a"
				theme[cached_end]="#d8a657"
				theme[available_start]="#b85a30"
				theme[available_mid]="#8b9a5a"
				theme[available_end]="#d8a657"
				theme[used_start]="#b85a30"
				theme[used_mid]="#8b9a5a"
				theme[used_end]="#d8a657"
				theme[download_start]="#b85a30"
				theme[download_mid]="#8b9a5a"
				theme[download_end]="#d8a657"
				theme[upload_start]="#b85a30"
				theme[upload_mid]="#8b9a5a"
				theme[upload_end]="#d8a657"
			'';
		};
	};
}
