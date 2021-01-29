{ stdenv, lib, makeDesktopItem, mymakeWrapper, patchelf, p7zip
, coreutils, gnugrep, which, git, unzip, libsecret, libnotify
}:

{ name, product, version, src, wmClass, jdk, meta , yourProgrameLoc }:

with stdenv.lib;

let loName = toLower product;
    hiName = toUpper product;
    execName = concatStringsSep "-" (init (splitString "-" name));
in

with stdenv; lib.makeOverridable mkDerivation rec {
  inherit name src meta;
  desktopItem = makeDesktopItem {
    name = execName;
    exec = execName;
    comment = lib.replaceChars ["\n"] [" "] meta.longDescription;
    desktopName = product;
    genericName = meta.description;
    categories = "Application;Development;";
    icon = execName;
    extraEntries = ''
      StartupWMClass=${wmClass}
    '';
  };

  nativeBuildInputs = [ mymakeWrapper patchelf unzip ];

  patchPhase = lib.optionalString (!stdenv.isDarwin) ''
      get_file_size() {
        local fname="$1"
        echo $(ls -l $fname | cut -d ' ' -f5)
      }

      munge_size_hack() {
        local fname="$1"
        local size="$2"
        strip $fname
        truncate --size=$size $fname
      }

      interpreter=$(echo ${stdenv.glibc.out}/lib/ld-linux*.so.2)
      if [ "${stdenv.hostPlatform.system}" == "x86_64-linux" ]; then
        target_size=$(get_file_size bin/fsnotifier64)
        patchelf --set-interpreter "$interpreter" bin/fsnotifier64
        munge_size_hack bin/fsnotifier64 $target_size
#         cp bin/fsnotifier64 /home/prehonor/Public/Program/datagrip/bin/
      else
        target_size=$(get_file_size bin/fsnotifier)
        patchelf --set-interpreter "$interpreter" bin/fsnotifier
        munge_size_hack bin/fsnotifier $target_size
#         cp bin/fsnotifier /home/prehonor/Public/Program/datagrip/bin/
      fi
  '';

  installPhase = ''
    mkdir -p $out/{bin,$name,share/pixmaps,libexec/${name}}
    cp -a . $out/$name
    ln -s $out/$name/bin/${loName}.png $out/share/pixmaps/${execName}.png
#     mv bin/fsnotifier* $out/libexec/${name}/.
#     chmod 755 $out/libexec/${name}/*
#     ln -s "${yourProgrameLoc}/bin/fsnotifier"  $out/libexec/${name}/fsnotifier
#     ln -s "${yourProgrameLoc}/bin/fsnotifier64"  $out/libexec/${name}/fsnotifier64

    jdk=${jdk.home}
    item=${desktopItem}

    makeWrapper "${yourProgrameLoc}/bin/${loName}.sh" "$out/bin/${execName}" \
      --prefix PATH : "${lib.optionalString (stdenv.isDarwin) "${jdk}/jdk/Contents/Home/bin:"}${stdenv.lib.makeBinPath [ jdk coreutils gnugrep which git ]}" \
      --prefix LD_LIBRARY_PATH : "${stdenv.lib.makeLibraryPath [
        # Some internals want libstdc++.so.6
        stdenv.cc.cc.lib libsecret
        libnotify
      ]}" \
      --set JDK_HOME "$jdk" \

      --set ANDROID_JAVA_HOME "$jdk" \
      --set JAVA_HOME "$jdk"

    ln -s "$item/share/applications" $out/share
  '';

} // stdenv.lib.optionalAttrs (!(meta.license.free or true)) {
  preferLocalBuild = true;
}
