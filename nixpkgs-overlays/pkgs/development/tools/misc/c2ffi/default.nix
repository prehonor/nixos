{ lib
, fetchFromGitHub
, cmake
, llvmPackages
, c2ffiBranch ? "llvm-13.0.0"
}:

llvmPackages.stdenv.mkDerivation {
  pname = "c2ffi-${c2ffiBranch}";
  version = "stable-2021-06-27";

  src = fetchFromGitHub {
    owner = "rpav";
    repo = "c2ffi";
    rev = "bfa50485ffa86b886215c72ea1e43dbd3acaf940";
    sha256 = "sha256-F6RhwvbHjrUkONiKVR+IxW0MRbNJk9iB9beH/4rChOQ=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    llvmPackages.llvm
    llvmPackages.clang
    llvmPackages.libclang
  ];

  # This isn't much, but...
  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/c2ffi --help 2>&1 >/dev/null
  '';

  # LLVM may be compiled with -fno-rtti, so let's just turn it off.
  # A mismatch between lib{clang,LLVM}* and us can lead to the link time error:
  # undefined reference to `typeinfo for clang::ASTConsumer'
  CXXFLAGS="-fno-rtti";

  meta = with lib; {
    homepage = "https://github.com/rpav/c2ffi";
    description = "An LLVM based tool for extracting definitions from C, C++, and Objective C header files for use with foreign function call interfaces";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ attila-lendvai ];
 };
}