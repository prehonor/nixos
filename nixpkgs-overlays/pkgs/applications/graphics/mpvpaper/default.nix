{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, cmake
, pkg-config
, libGL
, mpv
, wayland
, wayland-protocols
, wlroots
}:

stdenv.mkDerivation rec {
  pname = "mpvpaper";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "GhostNaN";
    repo = pname;
    rev = "${version}";
    sha256 = "sha256-1+noph6iXM5OSNMFQyta/ttGyZQ6F7bWDQi8W190G5E=";
  };

  nativeBuildInputs = [
    meson
    ninja
    cmake
    pkg-config
  ];

  buildInputs = [
    libGL
    mpv
    wayland
    wayland-protocols
    wlroots
  ];

  meta = with lib; {
    homepage = "https://github.com/GhostNaN/mpvpaper";
    description = "A video wallpaper program for wlroots based wayland compositors";
    license = licenses.gpl3;
    platforms = platforms.linux;
    # maintainers = with maintainers; [ wegank ];
  };
}