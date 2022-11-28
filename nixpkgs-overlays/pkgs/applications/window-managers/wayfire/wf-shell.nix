{ stdenv, lib, fetchFromGitHub, cmake, meson, ninja, pkg-config, wayland, git
, alsa-lib, gtkmm3, gtk-layer-shell, pulseaudio, wayfire, wf-config, wlroots_0_16
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
    rev = "c9639087aca3ad69bbd8f56f4213768639b4c8d0";
    sha256 = "sha256-eCga6ZdxqJYKc9yAI77fZUXOSaee8ijCE0XiJRJtDAg="; # 0000000000000000000000000000000000000000000000000000
    fetchSubmodules = true;
  };
  dontUseCmakeConfigure = true;
  nativeBuildInputs = [ cmake meson ninja pkg-config wayland ];
  buildInputs = [
    alsa-lib gtkmm3 gtk-layer-shell pulseaudio wayfire wf-config wlroots_0_16 
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
