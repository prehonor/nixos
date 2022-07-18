{ lib, stdenv, fetchFromGitHub, cmake, meson, ninja, pkg-config
, wayland, wayland-protocols, wf-config, wlroots, mesa
, cairo, pango, vulkan-headers, vulkan-loader, xorg, xwayland
, doctest, libdrm, libexecinfo, libinput, libjpeg, libxkbcommon, glslang, xcbutilerrors, xcbutilwm, seatd
, libevdev, nlohmann_json
# , glm, freetype, pixman, libcap
# , libuuid, libxml2, libpng
}:

stdenv.mkDerivation rec {
/*
  pname = "wayfire";
  version = "0.7.3";

  src = fetchurl {
    url = "https://github.com/WayfireWM/wayfire/releases/download/v${version}/wayfire-${version}.tar.xz";
    sha256 = "0pybay1lznf1md91wdh3np5q56pk5p84y2c4ckg3135q3ldxblcr";
  };
*/
  # url = "https://github.com/WayfireWM/${name}.git";
  pname = "wayfire";
  version = "0.8.0";
  src = fetchFromGitHub {
    owner = "WayfireWM";
    repo = "${pname}";
    rev = "75cc857e621ed9598b7a6fdd860cf5b690b348ff";
    sha256 = "sha256-yg78fyKAh3l26LglICf3/BPzOQa6uAbIbuiBsGGGgys="; # 0000000000000000000000000000000000000000000000000000
    fetchSubmodules = true;
  };
  /* patches = [
    # https://github.com/WayfireWM/wayfire/commit/2daec9bc30920c995700252b4915bbc2839aa1a3#diff-fff9797dc434bcdbb9cb1f1cb46f3a4f6de611034a0eaefe53dd0882b1095778
    # https://github.com/WayfireWM/wayfire/commit/883dacf8fe1eec5463269755879dfc71b481e7c9
    # https://github.com/WayfireWM/wayfire/commit/2daec9bc30920c995700252b4915bbc2839aa1a3
    ./upgrade-wlroots.diff
  ];
*/
  nativeBuildInputs = [ cmake meson ninja pkg-config wayland ];
  buildInputs = [
    cairo doctest libdrm libexecinfo libinput libjpeg libxkbcommon wayland
    wayland-protocols wf-config wlroots mesa pango
    vulkan-headers vulkan-loader xwayland xorg.xcbutilrenderutil 
    glslang xcbutilerrors seatd xcbutilwm
    # libuuid libxml2 libpng
    libevdev nlohmann_json # glm  freetype pixman libcap 
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
