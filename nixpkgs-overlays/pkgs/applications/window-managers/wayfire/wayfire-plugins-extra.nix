{
  cairo,
  fetchgit,
  glibmm,
  glm,
  cmake,
  libxkbcommon,
  xcbutilwm,
  meson,
  ninja,
  pango,
  udev,
  pkg-config,
  stdenv,
  wf-config,
  wlroots_0_16,
  wayfire,
  wayland,
  wayland-protocols,
}:

stdenv.mkDerivation rec {

  # 包含子模块，但是由于项目默认没有使用子模块所以暂时用fetchgit以备万一
  pname = "wayfire-plugins-extra";
  version = "0.8.0";
  src = fetchgit {
    url = "https://gitee.com/github-10784632_admin_admin/${pname}.git";
    rev = "ac7b7ed57f66793695f8725939b7df93cd10a27a";
    sha256 = "sha256-ZOkqsOvzuozsZc4EKLoVEUS8QMTIkqxbBKYb83VPSIo=";
    /*
    owner = "WayfireWM";
    repo = "${pname}";
    rev = "ac7b7ed57f66793695f8725939b7df93cd10a27a";
    sha256 = "sha256-ZOkqsOvzuozsZc4EKLoVEUS8QMTIkqxbBKYb83VPSIo=";*/
  };
  /* patches = [
    ./event-patch.diff
  ]; */

  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland
    cmake
  ];

  buildInputs = [
    cairo
    glibmm
    udev
    glm
    libxkbcommon
    xcbutilwm
    pango
    wlroots_0_16
    wf-config
    wayfire
    wayland
    wayland-protocols
  ];

  PKG_CONFIG_WAYFIRE_LIBDIR = "lib";
  PKG_CONFIG_WAYFIRE_METADATADIR = "share/wayfire/metadata";
}
