packages:
{ buildEnv, lib }:
let cli = builtins.head packages;
in
assert lib.assertMsg ((builtins.length packages) != 0)
    ''You must include at least one package, e.g
      `with dotnetCorePackages; combinePackages {
          packages = [ sdk_3_0 aspnetcore_2_1 ];
       };`'' ;
  buildEnv {
    name = "dotnet-core-combined";
    paths = packages;
    pathsToLink = [ "/host" "/packs" "/sdk" "/shared" "/templates" ];
    ignoreCollisions = true;
    postBuild = ''
      cp ${cli}/dotnet $out/dotnet
      mkdir $out/bin
      ln -s $out/dotnet $out/bin/
    '';
  }