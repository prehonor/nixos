{ stdenv, lib, fetchFromGitHub, meson, ninja, pkg-config, cmake, wayland, wayland-protocols, libxkbcommon, pango, cairo, wayfire, wf-config, wlroots
}:

stdenv.mkDerivation rec {
  # url = "https://github.com/soreau/${name}.git";
  pname = "wf-info";
  version = "0.7.0";
  src = fetchFromGitHub {
    owner = "soreau";
    repo = "${pname}";
    rev = "561c21365d3af07459dbca42156252018685a0f4";
    sha256 = "06zf23isq53whpvlhlck6bri5n3h51d42iwd8sv30x74g8zngisb"; 
  };

  nativeBuildInputs = [ meson ninja pkg-config cmake wayland ];
  buildInputs = [
    pango cairo wayfire wf-config wlroots wayland wayland-protocols libxkbcommon
  ];
  
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
