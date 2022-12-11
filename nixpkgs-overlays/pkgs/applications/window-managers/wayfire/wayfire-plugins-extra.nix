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
  wlroots_0_16,
  wayfire,
  wayland,
  wayland-protocols,
}:

stdenv.mkDerivation rec {

  # url = "https://github.com/WayfireWM/${name}.git";
  pname = "wayfire-plugins-extra";
  version = "0.8.0";
  src = fetchFromGitHub {
    owner = "WayfireWM";
    repo = "${pname}";
    rev = "945c01c9733644aba65af5595cc596c3c45a81cf"; # f6a083c2f42ae84212a61a770c9d2087d35cf392
    sha256 = "sha256-+XkZ+PXDWlf+32Ffq3Uc1LHQVKF9WCO4CDaRw+RmUhA="; # sha256-EOAGjjHklnqhurqXiXi/wKK6HAFyw2YQB2VxPB20q1k=
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
