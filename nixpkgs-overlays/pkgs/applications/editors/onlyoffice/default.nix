{ 
  stdenv
, mkDerivation
, fetchurl
, gnome3
, glib
, gtk3
, gtk2
, cairo
, atk
, gdk-pixbuf
, at-spi2-atk
, dbus
, dconf
, gst_all_1
, qtbase
, qtdeclarative
, qtsvg
, xorg
, nss
, nspr
, alsaLib
, makeFontsConf
, fontconfig
, xkeyboard_config
, libudev0-shim
, glibc
, curl
, libpulseaudio
, pulseaudio
, wrapGAppsHook
, autoPatchelfHook
, makeWrapper
, dpkg
}:

mkDerivation rec {
   pname = "onlyoffice-desktopeditors";
   version = "6.1.0";
   minor = "90";
   src = fetchurl {
   url = "https://github.com/ONLYOFFICE/DesktopEditors/releases/download/v${version}/onlyoffice-desktopeditors_${version}-${minor}_amd64.deb";
    sha256 = "sha256-TUaECChM3GxtB54/zNIKjRIocnAxpBVK7XsX3z7aq8o=";
   };


  buildInputs = [
      gnome3.gsettings_desktop_schemas
      glib
      gtk3
      gtk2
      cairo
      atk
      gdk-pixbuf
      at-spi2-atk
      dbus
      dconf
      gst_all_1.gstreamer
      gst_all_1.gst-plugins-base
      qtbase
      qtdeclarative
      qtsvg
      xorg.libX11
      xorg.libxcb
      xorg.xkeyboardconfig
      xorg.libXi
      xorg.libXcursor
      xorg.libXdamage
      xorg.libXrandr
      xorg.libXcomposite
      xorg.libXext
      xorg.libXfixes
      xorg.libXrender
      xorg.libXtst
      xorg.libXScrnSaver
      nss
      nspr
      alsaLib
      libpulseaudio
      fontconfig
  ];

  nativeBuildInputs = [
          wrapGAppsHook
          autoPatchelfHook
          makeWrapper
          dpkg
  ];
        runtimeLibs = stdenv.lib.makeLibraryPath [ libudev0-shim glibc curl pulseaudio ];
        
        fontsConf = makeFontsConf {
          fontDirectories = [];
        };

        unpackPhase = "dpkg-deb --fsys-tarfile $src | tar -x --no-same-permissions --no-same-owner";

        preConfigure = ''
          cp ${./font}/* opt/onlyoffice/desktopeditors/fonts/.
        '';

        installPhase = ''
          mkdir -p $out/share
          mkdir -p $out/{bin,lib}
          mv usr/bin/* $out/bin
          mv usr/share/* $out/share/
          mv opt/onlyoffice/desktopeditors $out/share
          ln -s $out/share/desktopeditors/DesktopEditors $out/bin/DesktopEditors

          wrapProgram $out/bin/DesktopEditors \
            --set QT_XKB_CONFIG_ROOT ${xkeyboard_config}/share/X11/xkb \
            --set QTCOMPOSE ${xorg.libX11.out}/share/X11/locale \
            --set FONTCONFIG_FILE ${fontsConf}

          substituteInPlace $out/share/applications/onlyoffice-desktopeditors.desktop \
            --replace "/usr/bin/onlyoffice-desktopeditors" "$out/bin/DesktopEditors" \
            --replace "Icon=onlyoffice-desktopeditors" "Icon=$out/share/desktopeditors/asc-de-32.png"
          '';

        preFixup = ''
          gappsWrapperArgs+=(--prefix LD_LIBRARY_PATH : "${runtimeLibs}" )
         '';

      enableParallelBuilding = true;
      meta = with stdenv.lib; {
        description = "GTrunSec";
        homepage = "https://github.com/GTrunSec/onlyoffice-desktopeditors-flake/blob/main/flake.nix";
        license = licenses.gpl3;
        maintainers = with maintainers; [ GTrunSec ];
        platforms = platforms.all;
      };
}