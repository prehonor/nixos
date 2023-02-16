{ stdenv, lib, fetchgit, cmake, meson, ninja, pkg-config
, doctest, glm, libevdev, libxml2, cairo, pango, libdrm, libinput, libxkbcommon, wayland, wayland-protocols
}:
let
  source = {
    stable = {
      version = "0.7.1";
      rev = "62e3897f207f49b1a3bbb85ba4b11d9fea239ec1";
      sha256 = "sha256-ADUBvDJcPYEB9ZvaFIgTfemo1WYwiWgCWX/z2yrEPtA=";
    };
    master = {
      version = "0.8.0";
      rev = "578b0bf3c81ef8f94e5e9b4f427720846bc7a5c5";
      sha256 = "sha256-v3QjYEpaxZNnFEQ9wPvds/lmLJwo8kUD07GENI7mlJk=";
    };
  };
in
stdenv.mkDerivation rec {

  pname = "wf-config";
  inherit (source.stable) version;

  src = fetchgit {
    url = "https://gitee.com/github-10784632_admin_admin/${pname}.git";
    inherit (source.stable) rev sha256;
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
