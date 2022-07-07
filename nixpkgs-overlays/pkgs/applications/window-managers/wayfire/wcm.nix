{ stdenv, lib, fetchFromGitHub, cmake, meson, ninja, pkg-config, wayland, wrapGAppsHook
, gtk3, libevdev, libepoxy, libxml2, wayfire, wayland-protocols, wf-config, wf-shell, wlroots
}:

stdenv.mkDerivation rec {
/*
  pname = "wcm";
  version = "0.7.0";

  src = fetchurl {

    url = "https://github.com/WayfireWM/wcm/releases/download/v${version}/wcm-${version}.tar.xz";
    sha256 = "19za1fnlf5hz4n4mxxwqcr5yxp6mga9ah539ifnjnqrgvj19cjlj";
  };
*/
# url = "https://github.com/WayfireWM/${name}.git";
  pname = "wcm";
  version = "0.8.0";
  src = fetchFromGitHub {
    owner = "WayfireWM";
    repo = "${pname}";
    rev = "07fa518f38042160f2291c5e74a0b9e16d667f79";
    sha256 = "sha256-AatajetC0H1maC0rx41Fb0ENH7L8blh3RfgW4rc4kTw="; # 0000000000000000000000000000000000000000000000000000
    fetchSubmodules = true;
  };
  dontUseCmakeConfigure = true;
  nativeBuildInputs = [ cmake meson ninja pkg-config wayland wrapGAppsHook ];
  buildInputs = [
    gtk3 libevdev libxml2 wayfire wayland libepoxy
    wayland-protocols wf-config wf-shell wlroots
  ];

  meta = with lib; {
    homepage = "https://github.com/WayfireWM/wcm";
    description = "Wayfire Config Manager";
    license = licenses.mit;
    maintainers = with maintainers; [ qyliss wucke13 ];
    platforms = platforms.unix;
  };
}
