{ stdenv, lib, fetchgit, meson, ninja, pkg-config, cmake, wayland, wayland-protocols, libxkbcommon, pango, cairo, wayfire, wf-config, wlroots_0_16
, gtkmm3, gobject-introspection ,libpulseaudio , alsa-lib, udev ,xcbutilwm ,libinput
}:

stdenv.mkDerivation rec {

  pname = "wf-info";
  version = "0.7.0";
  src = fetchgit {
    url = "https://gitee.com/github-10784632_admin_admin/${pname}.git";
    rev = "8247cd209ce5ad821b399841ea7adc993f929f79";
    sha256 = "sha256-4NRsoUUUyPIJ983U+nnDqZQ5X8Yv46ksv+GjZhsxqVg=";
    /*
    url = "https://gitee.com/github-10784632_admin_admin/${pname}/repository/archive/${version}.zip";
    sha256 = "sha256-JOqKS4PXLGw1QHtQHALznxxHTMCAN7b1Fq3MBM0GSw8=";

    owner = "soreau";
    repo = "${pname}";
    rev = "8247cd209ce5ad821b399841ea7adc993f929f79";
    sha256 = "sha256-JOqKS4PXLGw1QHtQHALznxxHTMCAN7b1Fq3MBM0GSw8=";*/
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
