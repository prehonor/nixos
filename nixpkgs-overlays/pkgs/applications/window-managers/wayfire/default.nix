{ lib, stdenv, fetchurl, cmake, meson, ninja, pkg-config
, wayland, wayland-protocols, wf-config, wlroots, mesa
, cairo, pango, vulkan-headers, vulkan-loader, xorg, xwayland
, doctest, libdrm, libexecinfo, libinput, libjpeg, libxkbcommon, glslang, xcbutilerrors, seatd
# , glm, libevdev, freetype, pixman, libcap
# , libuuid, xcbutilwm, libxml2, libpng
}:

stdenv.mkDerivation rec {
  pname = "wayfire";
  version = "0.7.3";

  src = fetchurl {
    url = "https://github.com/WayfireWM/wayfire/releases/download/v${version}/wayfire-${version}.tar.xz";
    sha256 = "0pybay1lznf1md91wdh3np5q56pk5p84y2c4ckg3135q3ldxblcr";
  };

  nativeBuildInputs = [ cmake meson ninja pkg-config wayland ];
  buildInputs = [
    cairo doctest libdrm libexecinfo libinput libjpeg libxkbcommon wayland
    wayland-protocols wf-config wlroots mesa pango
    vulkan-headers vulkan-loader xwayland xorg.xcbutilrenderutil 
    glslang xcbutilerrors seatd
    # libuuid  xcbutilwm libxml2 libpng
    # glm libevdev freetype pixman libcap
  ];

  # CMake is just used for finding doctest.
  dontUseCmakeConfigure = true;

  mesonFlags = [ "--sysconfdir" "/etc" ];

  meta = with lib; {
    homepage = "https://wayfire.org/";
    description = "3D Wayland compositor";
    license = licenses.mit;
    maintainers = with maintainers; [ qyliss wucke13 ];
    platforms = platforms.unix;
  };
}
