{
  cairo,
  fetchFromGitHub,
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

stdenv.mkDerivation rec {

  
/*
  pname = "wayfire-plugins-extra";
  version = "0.7.0";

  src = fetchurl {
    url = "https://github.com/WayfireWM/${pname}/releases/download/v${version}/${pname}-${version}.tar.xz";
    sha256 = "1sr195n2ch31j182bf3nkch17dk1dyx6vx51z3w9ql6mrr0b1p01";
  };

  pname = "wayfire-plugins-extra";
  version = "0.7.3";
  src = fetchFromGitHub {
    owner = "WayfireWM";
    repo = "${pname}";
    rev = "cf95ac721fb1909244d24ea5acaa5d04765696c7";
    sha256 = "sha256-QXEc/ZiDm7ihxvkM0T3HTwo9OL4/aJ8+HmB4NNTpGhY=";
  };
*/  
  # url = "https://github.com/WayfireWM/${name}.git";
  pname = "wayfire-plugins-extra";
  version = "0.8.0";
  src = fetchFromGitHub {
    owner = "WayfireWM";
    repo = "${pname}";
    rev = "9c862ebfdcf4f06faaa94b3fa1116d260f3c6658";
    sha256 = "1zayh9wflj7pi4g5mss6srgvrj7pn1wkscam1xi9wbwwgi9mxwp1";
  };
  /* patches = [
    ./event-patch.diff
  ];
*/
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
