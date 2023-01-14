{ stdenv, lib, fetchgit, meson, ninja, pkg-config, libxkbcommon, wayland, wayland-protocols, wayfire, wf-config, wlroots
, gtkmm3, gobject-introspection 
}:
let
  source = {       
    stable = {
      rev = "c7cc8e11e7f8fa2b725eb8feab6d05a8242709e7";
      sha256 = "sha256-2pOMvRLRF1CZlc+0r+JWt+8nqUdtFt68oiw6Fs0agcg=";
    };
    master = {
      rev = "f43768c29825a6c3b535fb82e941b493ad6c355f";
      sha256 = "sha256-cDE481cOMcM3HTIisBHYN/MKK+LE5Ub9TbyPYE1GbOk=";
    };
  };
in
stdenv.mkDerivation rec {

  pname = "wayfire-plugin_dbus_interface";
  version = "0.8.0";

  src = fetchgit {
    url = "https://gitee.com/github-10784632_admin_admin/${pname}.git";
    inherit (source.master) rev sha256;
  };

  nativeBuildInputs = [ meson ninja pkg-config wayland ];
  buildInputs = [
    wayfire wf-config wlroots wayland wayland-protocols libxkbcommon
    gtkmm3 gobject-introspection 
  ];
  # dontUseCmakeConfigure = true;
  PKG_CONFIG_WAYFIRE_LIBDIR = "lib";
  PKG_CONFIG_WAYFIRE_METADATADIR = "share/wayfire/metadata";

  meta = with lib; {
    homepage = "https://github.com/damianatorrpm/wayfire-plugin_dbus_interface";
    description = "DBus Wayfire plugin";
    license = licenses.mit;
    maintainers = with maintainers; [ damianatorrpm  ];
    platforms = platforms.unix;
  };
}
