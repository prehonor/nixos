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

    llvm_x = super.llvmPackages_12.llvm;
    libclang_x = super.llvmPackages_12.libclang;
    lld_x = super.lld_12;
    lldb_x = super.lldb_12;
    clang_x = super.clang_12;
    lua_x = super.lua5_3;
    nodejs_x = super.nodejs-14_x;
          /*
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
    python3 = super.python3.override {
        packageOverrides = final: prev: {
            python-lsp-server = final.callPackage ./pkgs/development/python-modules/python-lsp-server {};
            qdarkstyle = final.callPackage ./pkgs/development/python-modules/qdarkstyle {};
            qtconsole = final.callPackage ./pkgs/development/python-modules/qtconsole {};
            spyder-kernels = final.callPackage ./pkgs/development/python-modules/spyder-kernels {};
            qstylizer = final.callPackage ./pkgs/development/python-modules/qstylizer {};
            autopep8 = final.callPackage ./pkgs/development/python-modules/autopep8 {};
            # pbr = final.callPackage ./pkgs/development/python-modules/pbr {}; # 代价太大了
            spyder = final.callPackage ./pkgs/development/python-modules/spyder {};
         
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
            jupyter-client = prev.jupyter-client.overridePythonAttrs (oldAttrs: 
                rec {
                    version = "7.1.0";
                    pname = oldAttrs.pname;
                    src = prev.fetchPypi {
                        inherit pname version;
                        sha256 = "a5f995a73cffb314ed262713ae6dfce53c6b8216cea9f332071b8ff44a6e1654";
                    };
                }
            );

            eric6 = final.callPackage ./pkgs/development/python-modules/eric-ide {};
        };
    };
    fildem = super.callPackage ./pkgs/gnome/extensions/fildem/default.nix {};
   # python-lsp-server = super.python3.pkgs.callPackage ./pkgs/development/python-modules/python-lsp-server { };

/*
  	boost_x = super.boost175.override { enablePython = true; python = super.pkgs.python3; };
*/
    libmysqlclient_315 = super.libmysqlclient.override { version = "3.1.5"; };
/*
  	libmysqlconnectorcpp = super.libmysqlconnectorcpp.override { boost = boost_x; };
    */
    libredirect_x = super.callPackage ./pkgs/build-support/libredirect { };

    masterpdfeditor = super.libsForQt5.callPackage  ./pkgs/applications/misc/masterpdfeditor { };



  	jetbrains_x = (super.recurseIntoAttrs (super.callPackages ./pkgs/applications/editors/jetbrains {
    	vmopts = super.config.jetbrains.vmopts or null;
        jdk = super.jetbrains.jdk;
	  }) // {
	    jdk = super.callPackage ./pkgs/development/compilers/jetbrains-jdk {  };
	  });

/*
    jetbrains.pycharm-professional = super.jetbrains.pycharm-professional.overrideAttrs (
      oldAttrs: rec {
        src = /home/prehonor/Downloads/pycharm-professional-2021.2.2.tar.gz;
      }
    );
    
    super.jetbrains.webstorm = super.jetbrains.webstorm.overrideAttrs (
      oldAttrs: rec {
        src = /home/prehonor/Downloads/WebStorm-2021.2.2.tar.gz;
      }
    );

    super.jetbrains.clion = super.jetbrains.clion.overrideAttrs (
      oldAttrs: rec {
        src = /home/prehonor/Downloads/CLion-2021.3.tar.gz;
      }
    );
    
    super.jetbrains.idea-ultimate = super.jetbrains.idea-ultimate.overrideAttrs (
      oldAttrs: rec {
        src = /home/prehonor/Downloads/ideaIU-2021.3.tar.gz;
      }
    );

*/
    # 已使用julia-stable 该设置暂时无效
/*
	  julia = super.callPackage ./pkgs/development/compilers/julia/1.5.nix {
    	inherit (super.darwin.apple_sdk.frameworks) CoreServices ApplicationServices;
  	  };
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





  	# onlyoffice = super.callPackage ./pkgs/applications/office/onlyoffice-bin {};
    


  	# bcompare = super.libsForQt5.callPackage ./pkgs/applications/version-management/bcompare {};


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

