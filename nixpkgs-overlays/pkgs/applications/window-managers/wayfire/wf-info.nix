{ stdenv, lib, fetchgit, meson, ninja, pkg-config, cmake, wayland, wayland-protocols, libxkbcommon, pango, cairo, wayfire, wf-config, wlroots
, gtkmm3, gobject-introspection ,libpulseaudio , alsa-lib, udev ,xcbutilwm ,libinput
}:
let
  source = {
    stable = {
      version = "0.7.0";
      rev = "022800f180b1e6adfd4824c770ea9fd94ea4b5bf";
      sha256 = "sha256-JOqKS4PXLGw1QHtQHALznxxHTMCAN7b1Fq3MBM0GSw8=";
    };
    master = {
      version = "0.8.0";
      rev = "b63b4dde6f2930e567401d34538b79d514c676b5";
      sha256 = "sha256-58/ZdrPZCUhTGRZvTOXSS/pslf+Mj7ajdaiCDScZxcU=";
    };
  };
in
stdenv.mkDerivation rec {

  pname = "wf-info";
  inherit (source.stable) version;

  src = fetchgit {
    url = "https://gitee.com/github-10784632_admin_admin/${pname}.git";
    inherit (source.stable) rev sha256;
  };

  nativeBuildInputs = [ meson ninja pkg-config cmake wayland ];
  buildInputs = [
    pango cairo wayfire wf-config wlroots wayland wayland-protocols 
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
