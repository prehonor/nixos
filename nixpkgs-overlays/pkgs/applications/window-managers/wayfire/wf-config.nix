{ stdenv, lib, fetchFromGitHub, cmake, meson, ninja, pkg-config
, doctest, glm, libevdev, libxml2, cairo, pango, libdrm, libinput, libxkbcommon, wayland, wayland-protocols
}:

stdenv.mkDerivation rec {

  pname = "wf-config";
  version = "0.8.0";
  src = fetchFromGitHub {
    owner = "WayfireWM";
    repo = "${pname}";
    rev = "578b0bf3c81ef8f94e5e9b4f427720846bc7a5c5";
    sha256 = "sha256-v3QjYEpaxZNnFEQ9wPvds/lmLJwo8kUD07GENI7mlJk="; # 0000000000000000000000000000000000000000000000000000
  };
  nativeBuildInputs = [ cmake meson ninja pkg-config wayland-protocols ];
  buildInputs = [ doctest libevdev libxml2 wayland cairo pango libdrm libinput libxkbcommon ];
  propagatedBuildInputs = [ glm ];

  # CMake is just used for finding doctest.
  dontUseCmakeConfigure = true;

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/WayfireWM/wf-config";
    description = "Library for managing configuration files, written for Wayfire";
    license = licenses.mit;
    maintainers = with maintainers; [ qyliss wucke13 ];
    platforms = platforms.unix;
  };
}
