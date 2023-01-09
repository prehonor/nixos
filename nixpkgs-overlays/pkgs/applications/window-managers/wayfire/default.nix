{ lib, stdenv, fetchgit, cmake, meson, ninja, pkg-config
, wayland, wayland-protocols, wf-config, wlroots_0_16, mesa
, cairo, pango, vulkan-headers, vulkan-loader, xorg, xwayland
, doctest, libdrm, libexecinfo, libinput, libjpeg, libxkbcommon, glslang, xcbutilerrors, xcbutilwm, seatd
, libevdev, nlohmann_json
# , glm, freetype, pixman, libcap
# , libuuid, libxml2, libpng
}:

stdenv.mkDerivation rec {

  pname = "wayfire";
  version = "0.8.0";
  src = fetchgit {
    url = "https://gitee.com/github-10784632_admin_admin/${pname}.git";
    rev = "dceeb5f1775aec4ef59edb28ec3a2da93c7585fa";
    sha256 = "sha256-Kt4FDvhowF4+wm/wblMuAIZtKonzrAjj90KlAXzDfSw=";
/*
    owner = "WayfireWM";
    repo = "${pname}";
    rev = "6308d6ddecdda2cc62b488ef6b26a407960bd1fe";
    sha256 = "sha256-n++wu5bToYwdMenPUo/w3O7FvHCUQ6GuBy/HBVPvmkE=";
    */
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
