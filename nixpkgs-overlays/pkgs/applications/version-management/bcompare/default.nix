{ autoPatchelfHook, bzip2, cairo, coreutils, fetchurl, gdk-pixbuf, pango, gtk2, kcoreaddons, ki18n, kio, kservice, lib, qt4, qtbase, stdenv, runtimeShell }:

stdenv.mkDerivation rec {
  pname = "bcompare";
  version = "4.3.7.25118";

  src = fetchurl {
    url = "https://www.scootersoftware.com/${pname}-${version}_amd64.deb";
    sha256 = "165d6d81vy29pr62y4rcvl4abqqhfwdzcsx77p0dqlzgqswj88v8";
  };

  unpackPhase = ''
    ar x $src
    tar xfz data.tar.gz
  '';

  installPhase = ''
    mkdir -p $out/bin $out/lib $out/share
    cp -R usr/share $out/
    cp -R usr/lib $out/
    cp -R usr/bin $out/
    # Remove library that refuses to be autoPatchelf'ed
    rm $out/lib/beyondcompare/ext/bcompare_ext_kde.amd64.so
    substituteInPlace $out/bin/bcompare \
      --replace "/usr/lib/beyondcompare" "$out/lib/beyondcompare" \
      --replace "/bin/bash" "${runtimeShell}"
    # Create symlink bzip2 library
    ln -s ${bzip2.out}/lib/libbz2.so.1 $out/lib/beyondcompare/libbz2.so.1.0
    sed -i "s/keexjEP3t4Mue23hrnuPtY4TdcsqNiJL-5174TsUdLmJSIXKfG2NGPwBL6vnRPddT7tH29qpkneX63DO9ECSPE9rzY1zhThHERg8lHM9IBFT+rVuiY823aQJuqzxCKIE1bcDqM4wgW01FH6oCBP1G4ub01xmb4BGSUG6ZrjxWHJyNLyIlGvOhoY2HAYzEtzYGwxFZn2JZ66o4RONkXjX0DF9EzsdUef3UAS+JQ+fCYReLawdjEe6tXCv88GKaaPKWxCeaUL9PejICQgRQOLGOZtZQkLgAelrOtehxz5ANOOqCaJgy2mJLQVLM5SJ9Dli909c5ybvEhVmIC0dc9dWH+/N9KmiLVlKMU7RJqnE+WXEEPI1SgglmfmLc1yVH7dqBb9ehOoKG9UE+HAE1YvH1XX2XVGeEqYUY-Tsk7YBTz0WpSpoYyPgx6Iki5KLtQ5G-aKP9eysnkuOAkrvHU8bLbGtZteGwJarev03PhfCioJL4OSqsmQGEvDbHFEbNl1qJtdwEriR+VNZts9vNNLk7UGfeNwIiqpxjk4Mn09nmSd8FhM4ifvcaIbNCRoMPGl6KU12iseSe+w+1kFsLhX+OhQM8WXcWV10cGqBzQE9OqOLUcg9n0krrR3KrohstS9smTwEx9olyLYppvC0p5i7dAx2deWvM1ZxKNs0BvcXGukR+/g" $out/lib/beyondcompare/BCompare
  '';

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [
    stdenv.cc.cc.lib
    gtk2
    pango
    cairo
    kio
    kservice
    ki18n
    kcoreaddons
    gdk-pixbuf
    bzip2
  ];

  dontBuild = true;
  dontConfigure = true;

  meta = with lib; {
    description = "GUI application that allows to quickly and easily compare files and folders";
    longDescription = ''
      Beyond Compare is focused. Beyond Compare allows you to quickly and easily compare your files and folders.
      By using simple, powerful commands you can focus on the differences you're interested in and ignore those you're not.
      You can then merge the changes, synchronize your files, and generate reports for your records.
    '';
    homepage = "https://www.scootersoftware.com";
    license = licenses.unfree;
    maintainers = [ maintainers.ktor ];
    platforms = [ "x86_64-linux" ];
  };

}