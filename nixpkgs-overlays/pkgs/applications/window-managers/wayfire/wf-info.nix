{ stdenv, lib, fetchFromGitHub, meson, ninja, pkg-config, cmake, wayland, wayland-protocols, libxkbcommon, pango, cairo, wayfire, wf-config, wlroots_0_16
, gtkmm3, gobject-introspection ,libpulseaudio , alsa-lib, udev ,xcbutilwm ,libinput
}:

stdenv.mkDerivation rec {
  # url = "https://github.com/soreau/${name}.git";
  pname = "wf-info";
  version = "0.7.0";
  src = fetchFromGitHub {
    owner = "soreau";
    repo = "${pname}";
    rev = "022800f180b1e6adfd4824c770ea9fd94ea4b5bf";
    sha256 = "sha256-JOqKS4PXLGw1QHtQHALznxxHTMCAN7b1Fq3MBM0GSw8="; # 0000000000000000000000000000000000000000000000000000
  };

  nativeBuildInputs = [ meson ninja pkg-config cmake wayland ];
  buildInputs = [
    pango cairo wayfire wf-config wlroots_0_16 wayland wayland-protocols 
    libxkbcommon gtkmm3 gobject-introspection libpulseaudio alsa-lib 
    udev xcbutilwm libinput
  ];
  # dontUseCmakeConfigure = true;
  PKG_CONFIG_WAYFIRE_LIBDIR = "lib";
  PKG_CONFIG_WAYFIRE_METADATADIR = "share/wayfire/metadata";

  meta = with lib; {
    homepage = "https://github.com/soreau/wf-info";
    description = "A simple wayfire plugin and program to get information from wayfire";
    license = licenses.mit;
    maintainers = with maintainers; [ soreau ];
    platforms = platforms.unix;
  };
}
