self: super:

let 
   # 暂时没有临时变量 
in rec {
   # ventoy-bin = super.callPackage ./pkgs/tools/cd-dvd/ventoy-bin { };
    tor-browser-bundle-bin = super.tor-browser-bundle-bin.overrideAttrs (
      oldAttrs: rec {
        src = /home/prehonor/Downloads/tor-browser-linux64-10.5.6_en-US.tar.xz;
      }
    );
    microsoft-edge-stable = super.callPackage (import ./pkgs/applications/networking/browsers/edge).stable { };
    microsoft-edge-beta = super.callPackage (import ./pkgs/applications/networking/browsers/edge).beta { };
    microsoft-edge-dev = super.callPackage (import ./pkgs/applications/networking/browsers/edge).dev { };
    
    llvm_x = super.llvmPackages_latest.llvm;
    libclang_x = super.llvmPackages_latest.libclang;
    lld_x = super.llvmPackages_latest.lld;
    lldb_x = super.llvmPackages_latest.lldb;
    clang_x = super.llvmPackages_latest.clang;

    lua_x = super.lua5_4;

    wlr-protocols_x = super.callPackage ./pkgs/development/libraries/wlroots/protocols.nix { };
    wlroots_x = super.callPackage ./pkgs/development/libraries/wlroots {
        inherit (super.xorg) xcbutilrenderutil;
    };

    wayfireApplications = wayfireApplications-unwrapped.withPlugins (plugins: [ plugins.wf-shell plugins.wf-info plugins.wayfire-plugins-extra ]); 
    inherit (wayfireApplications) wayfire wcm ;
    wayfireApplications-unwrapped = super.recurseIntoAttrs (
        super.callPackage ./pkgs/applications/window-managers/wayfire/applications.nix { }
    );
    
    wayfirePlugins = super.recurseIntoAttrs (
        super.callPackage ./pkgs/applications/window-managers/wayfire/plugins.nix {
        inherit (wayfireApplications-unwrapped) wayfire;
    });
    wf-config = super.callPackage ./pkgs/applications/window-managers/wayfire/wf-config.nix { };
    mpvpaper = super.callPackage ./pkgs/applications/graphics/mpvpaper { };

    rizin_x = super.callPackage ./pkgs/development/tools/analysis/rizin { };

    cutter_x = super.libsForQt515.callPackage ./pkgs/development/tools/analysis/rizin/cutter.nix {  rizin = rizin_x; };

    python3 = super.python3.override {
        packageOverrides = final: prev: {
            pyzmq = prev.pyzmq.overridePythonAttrs (oldAttrs: 
                rec {
                    version = "23.2.0";
                    pname = oldAttrs.pname;
                    src = prev.fetchPypi {
                        inherit pname version;
                        sha256 = "sha256-pR8SqHGarZ3PtV1FYCLxa5CryN3n08qTzjEgtA4/oWk=";
                    };
                }
            );
            qtpy = prev.qtpy.overridePythonAttrs (oldAttrs: 
                rec {
                    version = "2.1.0";
                    pname = oldAttrs.pname;
                    src = prev.fetchPypi {
                        inherit pname version;
                        sha256 = "sha256-yozUIXF1GGNEKZ7kwPfnrc82LHCFK6NbJVpTQHcCXAY=";
                    };
                }
            );
            whatthepatch = final.callPackage ./pkgs/development/python-modules/whatthepatch {};
            python-lsp-server = final.callPackage ./pkgs/development/python-modules/python-lsp-server {};
            jupyter-client = final.callPackage ./pkgs/development/python-modules/jupyter-client {};
            spyder-kernels = final.callPackage ./pkgs/development/python-modules/spyder-kernels {};
            spyder = final.callPackage ./pkgs/development/python-modules/spyder {};
        };
    };

    # logseq = super.callPackage ./pkgs/applications/misc/logseq { };
    /*
    koreader_x = super.koreader.overrideAttrs (
      oldAttrs: rec {

        pname = "koreader";
        version = "2022.03.1";

        src = super.fetchurl {
            url =
                "https://github.com/koreader/koreader/releases/download/v${version}/koreader-${version}-amd64.deb";
            sha256 = "sha256-ZoqITWPR60G4xY9InrtIY9rCWUk0PidGFZokHLWl5ps=";
        };

      }
    );
    */
    /*
    logseq = super.logseq.overrideAttrs (
      oldAttrs: rec {

        pname = "logseq";
        version = "0.5.4";

        src = super.fetchurl {
          url = "https://github.com/logseq/logseq/releases/download/${version}/logseq-linux-x64-${version}.AppImage";
          sha256 = "PGrx2JBYmp5vQ8jLpOfiT1T1+SNeRt0W5oHUjHNKuBE=";
          name = "${pname}-${version}.AppImage";
        };

      }
    );
    unityhub = super.unityhub.overrideAttrs (
      oldAttrs: rec {

          version = "2.4.6";
          src = super.fetchurl {
           
            url = "https://prehonor-generic.pkg.coding.net/yigeren/pkgs/UnityHub.AppImage?version=${version}";
            sha256 = "0yp3rhv2jbi1bg7wws4nhr46slp2wnya7ly9j894ccllhnzijshn";
          };
          
        src = /home/prehonor/Downloads/UnityHub.AppImage;
      }
    );
    */
    /*
    python3 = super.python3.override {
        packageOverrides = final: prev: {
            
            qdarkstyle = final.callPackage ./pkgs/development/python-modules/qdarkstyle {};
            qtconsole = final.callPackage ./pkgs/development/python-modules/qtconsole {};
            
            qstylizer = final.callPackage ./pkgs/development/python-modules/qstylizer {};
            autopep8 = final.callPackage ./pkgs/development/python-modules/autopep8 {};
            pyqtchart = final.callPackage ./pkgs/development/python-modules/pyqtchart { 
                inherit (super.libsForQt5.qt5) qtbase qmake qtcharts; # inherit (super.libsForQt5) ;        
            };
         
            pyqtchart-qt = final.callPackage ./pkgs/development/python-modules/pyqtchart-qt {
                inherit (super.libsForQt5.qt5) full ; 
            };

            ipykernel = prev.ipykernel.overridePythonAttrs (oldAttrs: 
                rec {
                    version = "6.7.0";
                    pname = oldAttrs.pname;
                    src = prev.fetchPypi {
                        inherit pname version;
                        sha256 = "d82b904fdc2fd8c7b1fbe0fa481c68a11b4cd4c8ef07e6517da1f10cc3114d24";
                    };
                }
            );


            eric6 = final.callPackage ./pkgs/development/python-modules/eric-ide {};
        };
    };
    fildem = super.callPackage ./pkgs/gnome/extensions/fildem/default.nix {};
        */
        # pbr = final.callPackage ./pkgs/development/python-modules/pbr {}; # 代价太大了
    python-with-my-packages = super.python3.withPackages (python3Packages: with python3Packages; [
        pip urllib3 spyder ansible jupyter sip pyqtwebengine epc lxml pysocks pymupdf 
        pytaglib qrcode pyqt5  # pyqt5_with_qtmultimedia
    ]);

   # texmacs = super.texmacs.override { chineseFonts = true; };
   # python-lsp-server = super.python3.pkgs.callPackage ./pkgs/development/python-modules/python-lsp-server { };
   gdbgui_x = super.python3.pkgs.callPackage ./pkgs/development/tools/misc/gdbgui { };

/*
  	boost_x = super.boost175.override { enablePython = true; python = super.pkgs.python3; };

    libmysqlclient_315 = super.libmysqlclient.override { version = "3.1.5"; };
    */
/*
  	libmysqlconnectorcpp = super.libmysqlconnectorcpp.override { boost = boost_x; };
    */
    
    libredirect_x = super.callPackage ./pkgs/build-support/libredirect { };
/*
    masterpdfeditor = super.libsForQt5.callPackage  ./pkgs/applications/misc/masterpdfeditor { };
    unityhub_x = super.callPackage ./pkgs/development/tools/unityhub { };
*/

  	jetbrains_x = (super.recurseIntoAttrs (super.callPackages ./pkgs/applications/editors/jetbrains {
    	vmopts = super.config.jetbrains.vmopts or null;
        jdk = super.jetbrains.jdk;
	  }) // {
	   # jdk = super.callPackage ./pkgs/development/compilers/jetbrains-jdk {  };
	  });


/*
    jetbrains.pycharm-professional = super.jetbrains.pycharm-professional.overrideAttrs (
      oldAttrs: rec {
        src = /home/prehonor/Downloads/pycharm-professional-2021.2.2.tar.gz;
      }
    );

*/
    inherit (super.recurseIntoAttrs (super.callPackage ./pkgs/applications/editors/sublime/4/packages.nix { }))
    sublime4
    sublime4-dev;
/*
    cmake_x = super.libsForQt5.callPackage ./pkgs/development/tools/build-managers/cmake {
        inherit (super.darwin.apple_sdk.frameworks) SystemConfiguration;
    };

*/
    # libsForQt5_my = super.recurseIntoAttrs (super.lib.makeScope qt515_my.newScope super.mkLibsForQt5);

    # edraw = libsForQt5_my.callPackage ./pkgs/applications/misc/edraw {};

    # foliate = super.callPackage ./pkgs/applications/office/foliate { }; 21.05 已经加入


  	bcompare = super.libsForQt5.callPackage ./pkgs/applications/version-management/bcompare {};


  	# mymakeWrapper = super.makeSetupHook { deps = [ super.dieHook ]; substitutions = { shell = super.pkgs.runtimeShell; }; }
    #                         ./pkgs/build-support/setup-hooks/mymake-wrapper.sh;

/*
    flutterPackages = super.recurseIntoAttrs (super.callPackage ./pkgs/development/compilers/flutter { });
  	flutter = flutterPackages.stable;
  	flutter-beta = flutterPackages.beta;
  	flutter-dev = flutterPackages.dev;


  	dart = super.callPackage ./pkgs/development/interpreters/dart { };
  	dart_old = dart.override    { version = "1.24.3"; };
  	dart_stable = dart.override { version = "2.7.2"; };
	  dart_dev = dart.override    { version = "2.9.0-4.0.dev"; };
*/
/*

    android-studio = super.android-studio.overrideAttrs (
      oldAttrs: rec {
        src = /home/prehonor/Downloads/android-studio-2020.3.1.26-linux.tar.gz;
      }
    );
*/
/*
    libgpg-error = super.callPackage ./pkgs/development/libraries/libgpg-error { };
    libgpg-error-gen-posix-lock-obj = libgpg-error.override {
      genPosixLockObjOnly = true;
    };

    atomEnv = super.callPackage ./pkgs/applications/editors/atom/env.nix {
      gconf = super.gnome2.GConf;
    };
    atomPackages = super.dontRecurseIntoAttrs (super.callPackage ./pkgs/applications/editors/atom { });
    inherit (atomPackages) atom atom-beta;
*/

	
/*
    androidStudioPackages = super.recurseIntoAttrs
      (super.callPackage ./pkgs/applications/editors/android-studio {
        buildFHSUserEnv = super.buildFHSUserEnvBubblewrap;
      });
    android-studio = androidStudioPackages.stable;
 */


    # dotnetCorePackages = super.recurseIntoAttrs (super.callPackage ./pkgs/development/compilers/dotnet {});
    # dotnet-sdk_5 = dotnetCorePackages.sdk_5_0;

/*
    atom = super.atom.overrideAttrs (
      oldAttrs: rec {
        src = /home/prehonor/Downloads/atom-amd64.deb;
      }
    );
*/

/* 代价太大
    rustup = super.callPackage ./pkgs/development/tools/rust/rustup {
      inherit (super.darwin.apple_sdk.frameworks) CoreServices Security;
    };
*/
}

