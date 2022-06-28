{ stdenv, lib, fetchurl, meson, ninja, pkg-config, wayland, git
, alsa-lib, gtkmm3, gtk-layer-shell, pulseaudio, wayfire, wf-config, wlroots
}:

stdenv.mkDerivation rec {
  pname = "wf-shell";
  version = "0.7.0";

  # > Note to packagers: do not use the autogenerated "Source code"
  # > archives from GitHub, but the wf-shell-0.4.0.tar.xz file.
  src = fetchurl {
    url = "https://github.com/WayfireWM/wf-shell/releases/download/v${version}/wf-shell-${version}.tar.xz";
    sha256 = "1isybm9lcpxwyf6zh2vzkwrcnw3q7qxm21535g4f08f0l68cd5bl";
  };

  nativeBuildInputs = [ meson ninja pkg-config wayland ];
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
