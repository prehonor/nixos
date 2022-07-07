{ stdenv, lib, fetchFromGitHub, cmake, meson, ninja, pkg-config, wayland, git
, alsa-lib, gtkmm3, gtk-layer-shell, pulseaudio, wayfire, wf-config, wlroots
}:

stdenv.mkDerivation rec {
/*
  pname = "wf-shell";
  version = "0.7.0";
  src = fetchurl {
  url = "https://github.com/WayfireWM/${name}.git";
    url = "https://github.com/WayfireWM/wf-shell/releases/download/v${version}/wf-shell-${version}.tar.xz";
    sha256 = "1isybm9lcpxwyf6zh2vzkwrcnw3q7qxm21535g4f08f0l68cd5bl";
  };
*/
  pname = "wf-shell";
  version = "0.8.0";
  src = fetchFromGitHub { 
    owner = "WayfireWM";
    repo = "${pname}";
    rev = "8caa6a05e4e646af3bd16a470fefbf3639096d93";
    sha256 = "sha256-u2qWtpAqJ9CZkGjzZgtiKYZEYiw+Aq2KDQUtveu11Ec="; # 0000000000000000000000000000000000000000000000000000
    fetchSubmodules = true;
  };
  dontUseCmakeConfigure = true;
  nativeBuildInputs = [ cmake meson ninja pkg-config wayland ];
  buildInputs = [
    alsa-lib gtkmm3 gtk-layer-shell pulseaudio wayfire wf-config wlroots 
  ];

  mesonFlags = [ "--sysconfdir" "/etc" ];
  
  PKG_CONFIG_WAYFIRE_LIBDIR = "lib";
  PKG_CONFIG_WAYFIRE_METADATADIR = "share/wayfire/metadata";

  meta = with lib; {
    homepage = "https://github.com/WayfireWM/wf-shell";
    description = "GTK3-based panel for Wayfire";
    license = licenses.mit;
    maintainers = with maintainers; [ qyliss wucke13 ];
    platforms = platforms.unix;
  };
}
