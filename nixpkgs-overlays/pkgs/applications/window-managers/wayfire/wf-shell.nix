{ stdenv, lib, fetchgit, cmake, meson, ninja, pkg-config, wayland, git
, alsa-lib, gtkmm3, gtk-layer-shell, pulseaudio, wayfire, wf-config, wlroots
}:
let
  source = {
    stable = {
      rev = "c9639087aca3ad69bbd8f56f4213768639b4c8d0";
      sha256 = "sha256-eCga6ZdxqJYKc9yAI77fZUXOSaee8ijCE0XiJRJtDAg=";
    };
    master = {
      rev = "c9639087aca3ad69bbd8f56f4213768639b4c8d0";
      sha256 = "sha256-eCga6ZdxqJYKc9yAI77fZUXOSaee8ijCE0XiJRJtDAg=";
    };
  };
in
stdenv.mkDerivation rec {

  pname = "wf-shell";
  version = "0.8.0";

  src = fetchgit { 
    url = "https://gitee.com/github-10784632_admin_admin/${pname}.git";
    inherit (source.master) rev sha256;

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
