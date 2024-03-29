{ runCommand, lib, makeWrapper, wayfirePlugins }:

let
  inherit (lib) escapeShellArg makeBinPath;


  xmlPath = plugin: "${plugin}/share/wayfire/metadata";
  libPath = plugin: "${plugin}/lib/wayfire";
  # pluginLibs = lib.makeSearchPath "lib/wayfire" plugins;
  # pluginXmls = lib.makeSearchPath "share/wayfire/metadata" plugins;
  # xmlPath = plugin: "${plugin}/share/wayfire/metadata/wf-shell";
  # makePluginPath = lib.makeLibraryPath;
  makePluginPath = lib.concatMapStringsSep ":" libPath;
  makePluginXMLPath = lib.concatMapStringsSep ":" xmlPath;
in

application:

choosePlugins:

let
  plugins = choosePlugins wayfirePlugins;
in

runCommand "${application.name}-wrapped" {
  nativeBuildInputs = [ makeWrapper ];

  passthru = application.passthru // {
    unwrapped = application;
  };

  inherit (application) meta;
} ''
  mkdir -p $out/bin
  for bin in ${application}/bin/*
  do
      makeWrapper "$bin" $out/bin/''${bin##*/} \
          --suffix PATH : ${escapeShellArg (makeBinPath plugins)} \
          --suffix WAYFIRE_PLUGIN_PATH : ${escapeShellArg (makePluginPath plugins) } \
          --suffix WAYFIRE_PLUGIN_XML_PATH : ${escapeShellArg (makePluginXMLPath plugins)}
  done
  find ${application} -mindepth 1 -maxdepth 1 -not -name bin \
      -exec ln -s '{}' $out ';'
''
