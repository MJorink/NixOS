{ self, inputs, ... }: {
	perSystem = { pkgs, lib, ... }: {
		packages.myFoot = inputs.wrapper-modules.wrappers.foot.wrap {
			inherit pkgs;
			settings = {
				colors-dark = {
					foreground="e6dbd3";
					background="231d1b";
					regular0="1d1816";
					regular1="c25d4e";
					regular2="8b9a5a";
					regular3="d8a657";
					regular4="b85a30";
					regular5="cc8977";
					regular6="c4856a";
					regular7="b8aca2";
					bright0="463b38";
					bright1="d47761";
					bright2="8b9a5a";
					bright3="dbb98f";
					bright4="c86d45";
					bright5="cc8977";
					bright6="c4856a";
					bright7="e6dbd3";
					selection-foreground="1d1816";
					selection-background="b8aca2";
					cursor="1d1816 b85a30";
				};
				main = {
					font = "UbuntuMono Nerd Font:size=14";
				};
			};
		};
	};
}
