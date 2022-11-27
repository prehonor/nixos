{ lib, stdenv, fetchgit, meson, ninja, pkg-config, wayland-scanner
, libGL, wayland, wayland-protocols, libinput, libxkbcommon, pixman
, xcbutilwm, libX11, libcap, xcbutilimage, xcbutilerrors, mesa
, libpng, ffmpeg_4, xcbutilrenderutil, seatd, vulkan-loader, glslang
, nixosTests

, enableXWayland ? true, xwayland ? null
}:

stdenv.mkDerivation rec {
  name = "wlroots";
  src = fetchgit {
    url = "https://gitlab.freedesktop.org/${name}/${name}.git";
    rev = "5dc1d4671dd2ca3c1f0f09587c463fdbb542f0a4";
    sha256 = "0blp4d7g1ni59cy1di6nlk7wlb6h6pivvviaf8ndzh2r0b7k9m66"; 
    deepClone = false;
  };
  patches = [
    ./headless.diff
  ];

  # $out for the library and $examples for the example programs (in examples):
  outputs = [ "out" "examples" ];

  strictDeps = true;
  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [ meson ninja pkg-config wayland-scanner glslang ];

  buildInputs = [
    libGL wayland wayland-protocols libinput libxkbcommon pixman
    xcbutilwm libX11 libcap xcbutilimage xcbutilerrors mesa
    libpng ffmpeg_4 xcbutilrenderutil seatd vulkan-loader
  ]
    ++ lib.optional enableXWayland xwayland
  ;

  mesonFlags =
    lib.optional (!enableXWayland) "-Dxwayland=disabled"
  ;

  postFixup = ''
    # Install ALL example programs to $examples:
    # screencopy dmabuf-capture input-inhibitor layer-shell idle-inhibit idle
    # screenshot output-layout multi-pointer rotation tablet touch pointer
    # simple
    mkdir -p $examples/bin
    cd ./examples
    for binary in $(find . -executable -type f -printf '%P\n' | grep -vE '\.so'); do
      cp "$binary" "$examples/bin/wlroots-$binary"
    done
  '';

  # Test via TinyWL (the "minimum viable product" Wayland compositor based on wlroots):
  passthru.tests.tinywl = nixosTests.tinywl;

  meta = with lib; {
    description = "A modular Wayland compositor library";
    longDescription = ''
      Pluggable, composable, unopinionated modules for building a Wayland
      compositor; or about 50,000 lines of code you were going to write anyway.
    '';
    inherit (src.meta) homepage;
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ primeos synthetica ];
  };
}