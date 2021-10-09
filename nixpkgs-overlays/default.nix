self: super:

let 
   # 暂时没有临时变量 
in rec {


  	boost172_my = super.boost172.override { enablePython = true; python = super.pkgs.python3; };

    libmysqlclient_315 = super.libmysqlclient.override { version = "3.1.5"; };

  	libmysqlconnectorcpp = super.libmysqlconnectorcpp.override { boost = boost172_my; };
    libredirect = super.callPackage ./pkgs/build-support/libredirect { };

    masterpdfeditor = super.libsForQt5.callPackage  ./pkgs/applications/misc/masterpdfeditor { };


  	jetbrains = (super.recurseIntoAttrs (super.callPackages ./pkgs/applications/editors/jetbrains {
    	vmopts = super.config.jetbrains.vmopts or null;
        jdk = super.jetbrains.jdk;
	  }) // {
	    jdk = super.callPackage ./pkgs/development/compilers/jetbrains-jdk {  };
	  });

    # 已使用julia-stable 该设置暂时无效
	  julia = super.callPackage ./pkgs/development/compilers/julia/1.5.nix {
    	inherit (super.darwin.apple_sdk.frameworks) CoreServices ApplicationServices;
  	  };

    inherit (super.recurseIntoAttrs (super.callPackage ./pkgs/applications/editors/sublime/4/packages.nix { }))
    sublime4
    sublime4-dev;

    qt515_my = super.recurseIntoAttrs (super.makeOverridable
    (import ./pkgs/development/libraries/qt-5/5.15) {
      newScope = super.newScope;
      stdenv = super.stdenv;
      fetchurl = super.fetchurl;
      fetchpatch = super.fetchpatch;
      fetchFromGitHub = super.fetchFromGitHub; 
      makeSetupHook = super.makeSetupHook;
      makeWrapper = super.makeWrapper;
      bison = super.bison;
      cups = super.cups;
      dconf = super.dconf;
      harfbuzz = super.harfbuzz;
      libGL = super.libGL;
      perl = super.perl;
      gtk3 = super.gtk3;
      inherit (super.gst_all_1) gstreamer gst-plugins-base;
      llvmPackages_5 = super.llvmPackages_5;
    });

    # libsForQt5_my = super.recurseIntoAttrs (super.lib.makeScope qt515_my.newScope super.mkLibsForQt5);

    # edraw = libsForQt5_my.callPackage ./pkgs/applications/misc/edraw {};

    # foliate = super.callPackage ./pkgs/applications/office/foliate { }; 21.05 已经加入

    /*
  	atomEnv = super.callPackage ./pkgs/applications/editors/atom/env.nix {
    	gconf = super.gnome2.GConf;
  	};
    */
  	atomPackages = super.dontRecurseIntoAttrs (super.callPackage ./pkgs/applications/editors/atom { });
  	inherit (atomPackages) atom atom-beta;


  	onlyoffice = super.callPackage ./pkgs/applications/office/onlyoffice-bin {};


  	# bcompare = super.libsForQt5.callPackage ./pkgs/applications/version-management/bcompare {};


  	# mymakeWrapper = super.makeSetupHook { deps = [ super.dieHook ]; substitutions = { shell = super.pkgs.runtimeShell; }; }
    #                         ./pkgs/build-support/setup-hooks/mymake-wrapper.sh;


    flutterPackages = super.recurseIntoAttrs (super.callPackage ./pkgs/development/compilers/flutter { });
  	flutter = flutterPackages.stable;
  	flutter-beta = flutterPackages.beta;
  	flutter-dev = flutterPackages.dev;


  	dart = super.callPackage ./pkgs/development/interpreters/dart { };
  	dart_old = dart.override    { version = "1.24.3"; };
  	dart_stable = dart.override { version = "2.7.2"; };
	  dart_dev = dart.override    { version = "2.9.0-4.0.dev"; };
	

    androidStudioPackages = super.recurseIntoAttrs
      (super.callPackage ./pkgs/applications/editors/android-studio {
        buildFHSUserEnv = super.buildFHSUserEnvBubblewrap;
      });
    android-studio = androidStudioPackages.stable;

    # dotnetCorePackages = super.recurseIntoAttrs (super.callPackage ./pkgs/development/compilers/dotnet {});
    # dotnet-sdk_5 = dotnetCorePackages.sdk_5_0;

/* 代价太大
    rustup = super.callPackage ./pkgs/development/tools/rust/rustup {
      inherit (super.darwin.apple_sdk.frameworks) CoreServices Security;
    };
*/
}

