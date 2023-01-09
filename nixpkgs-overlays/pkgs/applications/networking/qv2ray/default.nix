{ lib
, stdenv
, mkDerivation
, fetchFromGitHub
, qttools
, cmake
, grpc
, protobuf
, openssl
, pkg-config
, c-ares
, libGL
, zlib
, curl
}:

mkDerivation rec {
  pname = "qv2ray";
  version = "unstable-2022-09-25";

  src = fetchFromGitHub {
  	owner = "Qv2ray";
  	repo = "Qv2ray";
  	rev = "fb44fb1421941ab192229ff133bc28feeb4a8ce5";
    sha256 = "sha256-TngDgLXKyAoQFnXpBNaz4QjfkVwfZyuQwatdhEiI57U=";
  	fetchSubmodules = true;
  };

  patchPhase = lib.optionals stdenv.isDarwin ''
    substituteInPlace cmake/platforms/macos.cmake \
      --replace \''${QV2RAY_QtX_DIR}/../../../bin/macdeployqt macdeployqt
  '';

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DQV2RAY_DISABLE_AUTO_UPDATE=on"
    "-DQV2RAY_USE_V5_CORE=on"
    "-DQV2RAY_TRANSLATION_PATH=${placeholder "out"}/share/qv2ray/lang"
  ];

  preConfigure = ''
    export _QV2RAY_BUILD_INFO_="Qv2ray Nixpkgs"
    export _QV2RAY_BUILD_EXTRA_INFO_="(Nixpkgs build) nixpkgs"
  '';

  buildInputs = [
    libGL
    zlib
    grpc
    protobuf
    openssl
    c-ares
  ];

  nativeBuildInputs = [
    cmake

    # The default clang_7 will result in reproducible ICE.

    pkg-config
    qttools
    curl
  ];

  meta = with lib; {
    description = "An GUI frontend to v2ray";
    homepage = "https://qv2ray.net";
    license = licenses.gpl3;
    maintainers = with maintainers; [ poscat ];
    platforms = platforms.all;
  };
}