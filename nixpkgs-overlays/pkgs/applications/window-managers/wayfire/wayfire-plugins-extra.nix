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
  wlroots,
  wayfire,
  wayland,
  wayland-protocols,
}:
let
  source = {
    stable = {
      rev = "b698f613763d02c30cdc642b35d6e8e98252b936";
      sha256 = "sha256-hnsRwIrl0+pRKhRlrF/Wdlu6HkzLfYukGk4Hzx3wNeo=";
    };

    fast = {
      rev = "69c3414b07818a6dc655e35ef025681c80e9027f";
      sha256 = "sha256-nzNbVlrZOuL5AFwTRJs6jRvxVzUz/cDONdkYiGRRGgQ=";
    };
  };
in
stdenv.mkDerivation rec {

  # 包含子模块，但是由于项目默认没有使用子模块所以暂时用fetchgit以备万一
  pname = "wayfire-plugins-extra";
  version = "0.7.5";
  
  src = fetchgit {
    url = "https://gitee.com/github-10784632_admin_admin/${pname}.git";
    inherit (source.stable) rev sha256;
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
    wlroots
    wf-config
    wayfire
    wayland
    wayland-protocols
  ];

  PKG_CONFIG_WAYFIRE_LIBDIR = "lib";
  PKG_CONFIG_WAYFIRE_METADATADIR = "share/wayfire/metadata";
}
