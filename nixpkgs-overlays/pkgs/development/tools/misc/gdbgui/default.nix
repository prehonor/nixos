{ lib
, buildPythonApplication
, fetchPypi
, gdb
, flask-socketio
, flask-compress
, pygdbmi
, pygments
, greenlet
, eventlet
, perl
}:

buildPythonApplication rec {
  pname = "gdbgui";

  version = "0.15.1.0";


  buildInputs = [ gdb ];
  nativeBuildInputs = [ perl ];
  propagatedBuildInputs = [
    flask-socketio
    flask-compress
    pygdbmi
    pygments
    greenlet
    eventlet
  ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "0wr5ri1pza6iglxcw2mlf5afqw4dvypvg22dkdfjgsyddsiggh31";
  };

  postPatch = ''
    echo ${version} > gdbgui/VERSION.txt
    # remove upper version bound
    # sed -ie 's/==.*//g;s/dnspython/&==2.2.1/' requirements.txt
    perl -pi -e 's/(?<!dnspython)==.+//g' requirements.txt # sed 不支持非贪婪模式
  '';

  postInstall = ''
    wrapProgram $out/bin/gdbgui \
      --prefix PATH : ${lib.makeBinPath [ gdb ]}
  '';

  # tests do not work without stdout/stdin
  doCheck = false;

  meta = with lib; {
    description = "A browser-based frontend for GDB";
    homepage = "https://www.gdbgui.com/";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ yrashk dump_stack ];
  };
}