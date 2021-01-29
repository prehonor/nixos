self: super:

let 
   # 暂时没有临时变量
in rec {


  	boost172_my = super.boost172.override { enablePython = true; python = super.pkgs.python3; };


  	libmysqlconnectorcpp = super.libmysqlconnectorcpp.override { boost = boost172_my; };


  	jetbrains = (super.recurseIntoAttrs (super.callPackages ./pkgs/applications/editors/jetbrains {
    	vmopts = super.config.jetbrains.vmopts or null;
        jdk = super.jetbrains.jdk;
	  }) // {
	    jdk = super.callPackage ./pkgs/development/compilers/jetbrains-jdk {  };
	  });


	julia = super.callPackage ./pkgs/development/compilers/julia/1.5.nix {
    	inherit (super.darwin.apple_sdk.frameworks) CoreServices ApplicationServices;
  	  };


  	atomEnv = super.callPackage ./pkgs/applications/editors/atom/env.nix {
    	gconf = super.gnome2.GConf;
  	};
  	atomPackages = super.dontRecurseIntoAttrs (super.callPackage ./pkgs/applications/editors/atom { });
  	inherit (atomPackages) atom atom-beta;


  	onlyoffice = super.libsForQt5.callPackage ./pkgs/applications/editors/onlyoffice {};


  	bcompare = super.libsForQt5.callPackage ./pkgs/applications/version-management/bcompare {};


  	mymakeWrapper = super.makeSetupHook { deps = [ super.dieHook ]; substitutions = { shell = super.pkgs.runtimeShell; }; }
                              ./pkgs/build-support/setup-hooks/mymake-wrapper.sh;


    flutterPackages = super.recurseIntoAttrs (super.callPackage ./pkgs/development/compilers/flutter { });
  	flutter = flutterPackages.stable;
  	flutter-beta = flutterPackages.beta;
  	flutter-dev = flutterPackages.dev;


  	dart = super.callPackage ./pkgs/development/interpreters/dart { };
  	dart_old = dart.override    { version = "1.24.3"; };
  	dart_stable = dart.override { version = "2.7.2"; };
	dart_dev = dart.override    { version = "2.9.0-4.0.dev"; };
	

}

