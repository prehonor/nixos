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
, qtsensors
, qt3d
, qtgamepad
, qttools
, qtserialbus
, qtserialport
, libdrm
, libxkbcommon
, pango
, cups
, postgresql
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
   pname = "edraw";
   version = "10.5.3";
   minor = "90";
   src = /ah/prehonor/Programmers/edrawmax-10-5-cn.deb;


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
      qtsensors
      qt3d
      qtgamepad
      qttools
      qtserialbus
      qtserialport

      libdrm
      libxkbcommon
      pango
      cups
      postgresql.lib

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
        runtimeLibs = lib.makeLibraryPath [ libudev0-shim glibc curl pulseaudio ];
        
        fontsConf = makeFontsConf {
          fontDirectories = [];
        };

        unpackPhase = "dpkg-deb --fsys-tarfile $src | tar -x --no-same-permissions --no-same-owner";


        installPhase = ''


          mkdir -p $out/share/{pixmaps,applications}
          mkdir -p $out/bin

          mv opt/EdrawMax-10/edrawmax.png $out/share/pixmaps
          mv opt/EdrawMax-10/edrawmax.desktop $out/share/applications
          mv opt/EdrawMax-10 $out/share



          ln -s $out/share/EdrawMax-10/EdrawMax $out/bin/EdrawMax


          wrapProgram $out/bin/EdrawMax \
            --set QT_XKB_CONFIG_ROOT ${xkeyboard_config}/share/X11/xkb \
            --set QTCOMPOSE ${xorg.libX11.out}/share/X11/locale \
            --set FONTCONFIG_FILE ${fontsConf}


          substituteInPlace $out/share/applications/edrawmax.desktop \
            --replace 'Exec=/opt/EdrawMax-10' "Exec==$out/bin" \
            --replace "Icon=/opt/EdrawMax-10" "Icon=$out/share/pixmaps"


        '';

        preFixup = ''
          gappsWrapperArgs+=(--prefix LD_LIBRARY_PATH : "${runtimeLibs}" )
         '';

      enableParallelBuilding = true;
      meta = with lib; {
        description = "GTrunSec";
        homepage = "https://github.com/prehonor";
        license = licenses.gpl3;
        maintainers = with maintainers; [ GTrunSec ];
        platforms = platforms.all;
      };
}