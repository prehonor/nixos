{ lib
, stdenv
, fetchFromGitLab
, meson
, ninja
, pkg-config
, wayland-scanner
, libGL
, wayland
, wayland-protocols
, libinput
, libxkbcommon
, pixman
, libcap
, mesa
, xorg
, libpng
, ffmpeg_4
, hwdata
, seatd
, vulkan-loader
, glslang
, nixosTests
, cmake
, enableXWayland ? true
, xwayland ? null
}:

let
  generic = { version, hash, extraBuildInputs ? [ ], extraNativeBuildInputs ? [ ], extraPatch ? "" }:
    stdenv.mkDerivation rec {
      pname = "wlroots";
      inherit version;

      src = fetchFromGitLab {
        domain = "gitlab.freedesktop.org";
        owner = "wlroots";
        repo = "wlroots";
        rev = version;
        inherit hash;
      };

      postPatch = extraPatch;

      # $out for the library and $examples for the example programs (in examples):
      outputs = [ "out" "examples" ];

      strictDeps = true;
      depsBuildBuild = [ pkg-config ];

      nativeBuildInputs = [ meson ninja pkg-config wayland-scanner cmake ]
        ++ extraNativeBuildInputs;

      buildInputs = [
        ffmpeg_4
        libGL
        libcap
        libinput
        libpng
        libxkbcommon
        mesa
        pixman
        seatd
        vulkan-loader
        wayland
        wayland-protocols
        xorg.libX11
        xorg.xcbutilerrors
        xorg.xcbutilimage
        xorg.xcbutilrenderutil
        xorg.xcbutilwm
      ]
      ++ lib.optional enableXWayland xwayland
      ++ extraBuildInputs;

      mesonFlags =
        lib.optional (!enableXWayland) "-Dxwayland=disabled"
      ;
      
      dontUseCmakeConfigure = true;

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
        changelog = "https://gitlab.freedesktop.org/wlroots/wlroots/-/tags/${version}";
        license = licenses.mit;
        platforms = platforms.linux;
        maintainers = with maintainers; [ primeos synthetica ];
      };
    };

in
rec {

  wlroots_0_15 = generic {
    version = "0.15.1";
    hash = "sha256-MFR38UuB/wW7J9ODDUOfgTzKLse0SSMIRYTpEaEdRwM=";
    extraBuildInputs = [ vulkan-loader ];
    extraNativeBuildInputs = [ glslang ];
  };
  
  wlroots_0_16_0 = generic {
     version = "1712a7d27444d62f8da8eeedf0840b386a810e96"; # 0.16.0 
    hash = "sha256-k7BFx1xvvsdCXNWX0XeZYwv8H/myk4p42i2Y6vjILqM=";
    extraBuildInputs = [ vulkan-loader ];
    extraNativeBuildInputs = [ glslang ];
    extraPatch = ''
      substituteInPlace backend/drm/meson.build \
        --replace /usr/share/hwdata/ ${hwdata}/share/hwdata/
    '';
  };

  wlroots_0_16_1 = generic {
    version = "0911a41f17df2f684c383923772994a3807ce416"; # 0.16.1 
    hash = "sha256-UyPN7zmytre4emwx/ztZ4JefXHwixPV6UEEqnhSLbIY=";
    extraBuildInputs = [ vulkan-loader ];
    extraNativeBuildInputs = [ glslang ];
    extraPatch = ''
      substituteInPlace backend/drm/meson.build \
        --replace /usr/share/hwdata/ ${hwdata}/share/hwdata/
    '';
  };
  
  wlroots_0_16 = generic {
    version = "9c7db7124edea044a89c5872742f8bd09adb1140"; # 0.16 
    hash = "sha256-bYCSXRSAtVMOfJQ44uwC2gqlfjDcetI7X1bbVzrRZzU=";
    extraBuildInputs = [ vulkan-loader ];
    extraNativeBuildInputs = [ glslang ];
    extraPatch = ''
      substituteInPlace backend/drm/meson.build \
        --replace /usr/share/hwdata/ ${hwdata}/share/hwdata/
    '';
  };
  
  wlroots = wlroots_0_16_0;

}