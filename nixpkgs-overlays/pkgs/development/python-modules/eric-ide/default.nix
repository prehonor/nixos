{ lib, buildPythonPackage, fetchPypi, isPy27, makeDesktopItem, 
  wheel, 
  pyqt5, 
  pyqtchart, 
  pyqtwebengine, 
  qscintilla-qt5, 
  docutils, 
  markdown, 
  pyyaml, 
  toml, 
  chardet, 
  asttokens, 
  editorconfig, 
  send2trash, 
  pygments
}:
buildPythonPackage rec {

  pname = "eric-ide";
  version = "21.11";


  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "c744dac78acf03e817df3fa52408d1d634eb6a40bff57c447f4044837f28db6e";
  };


  nativeBuildInputs = [ pyqtwebengine.wrapQtAppsHook ];
  propagatedBuildInputs = [ 
    wheel
    pyqt5
    pyqtchart
    pyqtwebengine
    qscintilla-qt5
    docutils
    markdown
    pyyaml
    toml
    chardet
    asttokens
    editorconfig
    send2trash
    pygments
  ];
  doCheck = false;

  desktopItem = makeDesktopItem {
    name = "eric6";
    exec = "eric6";
    icon = "eric";
    comment = "Scientific Python Development Environment";
    desktopName = "eric6";
    genericName = "Eirc IDE";
    categories = "Development;IDE;";
  };
  

  postInstall = ''
    # add Python libs to env so Spyder subprocesses
    # created to run compute kernels don't fail with ImportErrors
    # wrapProgram $out/bin/eric6 --prefix PYTHONPATH : "$PYTHONPATH"
    # Create desktop item
    mkdir -p $out/share/icons
    cp eric6/icons/breeze-light/eric.svg $out/share/icons
    cp -r $desktopItem/share/applications/ $out/share
  '';

  dontWrapQtApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  meta = with lib; {
    description = "eric6 is a full featured Python editor and IDE, written in Python. It is based on the cross platform Qt UI toolkit, integrating the highly flexible Scintilla editor control";
    longDescription = ''
      eric6 is a full featured Python editor and IDE, written in Python. It is based on the cross platform Qt UI toolkit, integrating the highly flexible Scintilla editor control. It is designed to be usable as everyday quick and dirty editor as well as being usable as a professional project management tool integrating many advanced features Python offers the professional coder. eric6 includes a plug-in system, which allows easy extension of the IDE functionality with plug-ins downloadable from the net. For more details see <https://eric-ide.python-projects.org>.
    '';
    homepage = "https://eric-ide.python-projects.org/";
    downloadPage = "https://eric-ide.python-projects.org/eric-download.html";
    changelog = "https://tracker.die-offenbachs.homelinux.org/eric/index";
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ Detlev_Offenbach ];
  };

}