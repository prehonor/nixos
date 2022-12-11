{ lib, stdenv, fetchFromGitHub, cmake, meson, ninja, pkg-config
, wayland, wayland-protocols, wf-config, wlroots_0_16, mesa
, cairo, pango, vulkan-headers, vulkan-loader, xorg, xwayland
, doctest, libdrm, libexecinfo, libinput, libjpeg, libxkbcommon, glslang, xcbutilerrors, xcbutilwm, seatd
, libevdev, nlohmann_json
# , glm, freetype, pixman, libcap
# , libuuid, libxml2, libpng
}:

stdenv.mkDerivation rec {

  # url = "https://github.com/WayfireWM/${name}.git";
  pname = "wayfire";
  version = "0.8.0";
  src = fetchFromGitHub {
    owner = "WayfireWM";
    repo = "${pname}";
    rev = "d296170e28ccefc38586cd6ab8ee5de39e046563"; # c3b1edf11e377778f5e267c7ad7cf93d22078903
    sha256 = "sha256-yItoMoBY4OR+S0f4uEbcnkZS+byZ3Ot4dI/BjoITcto="; # 0000000000000000000000000000000000000000000000000000
    fetchSubmodules = true;
  };
  /* patches = [
    # https://github.com/WayfireWM/wayfire/commit/2daec9bc30920c995700252b4915bbc2839aa1a3#diff-fff9797dc434bcdbb9cb1f1cb46f3a4f6de611034a0eaefe53dd0882b1095778
    # https://github.com/WayfireWM/wayfire/commit/883dacf8fe1eec5463269755879dfc71b481e7c9
    # https://github.com/WayfireWM/wayfire/commit/2daec9bc30920c995700252b4915bbc2839aa1a3
    ./upgrade-wlroots.diff
  ]; */

  nativeBuildInputs = [ cmake meson ninja pkg-config wayland ];
  buildInputs = [
    cairo doctest libdrm libexecinfo libinput libjpeg libxkbcommon wayland
    wayland-protocols wf-config wlroots_0_16 mesa pango
    vulkan-headers vulkan-loader xwayland xorg.xcbutilrenderutil 
    glslang xcbutilerrors seatd xcbutilwm
    # libuuid libxml2 libpng
    libevdev nlohmann_json # glm  freetype pixman libcap 
  ];

  # CMake is just used for finding doctest.
  dontUseCmakeConfigure = true;

  mesonFlags = [ "--sysconfdir" "/etc" 
    "-Duse_system_wlroots=enabled"
    "-Duse_system_wfconfig=enabled" 
    ];

  meta = with lib; {
    homepage = "https://wayfire.org/";
    description = "3D Wayland compositor";
    license = licenses.mit;
    maintainers = with maintainers; [ qyliss wucke13 ];
    platforms = platforms.unix;
  };
}
