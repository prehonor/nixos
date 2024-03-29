{ lib, stdenv, fetchgit, cmake, meson, ninja, pkg-config
, wayland, wayland-protocols, wf-config, wlroots, mesa
, cairo, pango, vulkan-headers, vulkan-loader, xorg, xwayland
, doctest, libdrm, libexecinfo, libinput, libjpeg, libxkbcommon, glslang, xcbutilerrors, xcbutilwm, seatd
, libevdev, nlohmann_json
# , glm, freetype, pixman, libcap
# , libuuid, libxml2, libpng
}:
let
  source = {
    stable = {
      version = "0.7.5";
      rev = "1e9092b5ffe878d1cdecefa1997de4a665cf6212";
      sha256 = "sha256-Z+rR9pY244I3i/++XZ4ROIkq3vtzMgcxxHvJNxFD9is=";
    };

    master = {
      version = "0.8.0";
      rev = "a1f575701ab3ba41006a38c0a01f39d31fdf2dbb";
      sha256 = "sha256-GfvtD1UEHTcYRH5/E7mtL7g3253PsPQbxuQOP9lbejU";
    };

  };
in
stdenv.mkDerivation rec {

  pname = "wayfire";
  inherit (source.stable) version;
  
  
  src = fetchgit {
    url = "https://gitee.com/github-10784632_admin_admin/${pname}.git";
    
    inherit (source.stable) rev sha256;
    
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
    wayland-protocols wf-config wlroots mesa pango
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
