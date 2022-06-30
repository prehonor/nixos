{
  cairo,
  fetchgit,
  glibmm,
  glm,
  cmake,
  libxkbcommon,
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

stdenv.mkDerivation rec {

  name = "wayfire-plugins-extra";
/*
  pname = "wayfire-plugins-extra";
  version = "0.7.0";

  src = fetchurl {
    url = "https://github.com/WayfireWM/${pname}/releases/download/v${version}/${pname}-${version}.tar.xz";
    sha256 = "1sr195n2ch31j182bf3nkch17dk1dyx6vx51z3w9ql6mrr0b1p01";
  };
*/  
  src = fetchgit {
    url = "https://github.com/WayfireWM/${name}.git";
    rev = "cf95ac721fb1909244d24ea5acaa5d04765696c7";
    sha256 = "sha256-QXEc/ZiDm7ihxvkM0T3HTwo9OL4/aJ8+HmB4NNTpGhY=";
    deepClone = false;
  };
  

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