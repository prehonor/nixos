{ lib, buildPythonPackage, fetchPypi, isPy27, makeDesktopItem, 
  atomicwrites,
  chardet,
  cloudpickle,
  cookiecutter, # 新添加
  diff-match-patch,
  intervaltree,
  ipython, # 新添加
  jedi,
  jellyfish, # 新添加
  jsonschema, # 新添加
  keyring,
  nbconvert,
  numpydoc,
  parso, # 新添加
  pexpect, # 新添加
  pickleshare, # 新添加
  psutil,
  pygments,
  pylint,
  python-lsp-black, # 新添加 且依赖  python-lsp-server # Black plugin for the Python LSP Server
  pyls-spyder,
  pyqt5, # 新添加
  pyqtwebengine,
  python-lsp-server, # 版本过低 需要覆盖
  pyxdg,
  pyzmq,
  qdarkstyle,        # 版本过低 需要覆盖 3.0.2
  qstylizer,         # 新添加 nixos 没有
  qtawesome,
  qtconsole,        # 版本过低 需要覆盖 >=5.2.1
  qtpy,
  Rtree,      # 新添加
  setuptools,  # 新添加
  sphinx,  # 新添加
  spyder-kernels,    # 版本过低 需要覆盖 >=2.2.0,<2.3.0 
  # 下面的包 spyder 源码不需要
  tinycss2,  # 新添加
  inflection,  # 新添加
  textdistance,
  three-merge,
  watchdog,  # Python API and shell utilities to monitor file system events
  pycodestyle,  
  rope, 
  numpy,
  scipy,
  matplotlib,
  mccabe,
  pyopengl,  # PyOpenGL, the Python OpenGL bindings
  flake8,    # Flake8 is a wrapper around pyflakes, pycodestyle and mccabe
}:

buildPythonPackage rec {
  pname = "spyder";
  version = "5.2.1";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "b318a70a75acd200018a547d2ff2d2f55e7507054469d0c77ec6f967ac3c2d28";
  };


#  src = /gh/prehonor/gitproject/spyder;
  nativeBuildInputs = [ pyqtwebengine.wrapQtAppsHook ];

  propagatedBuildInputs = [ 
    atomicwrites
    chardet
    cloudpickle
    cookiecutter # 新添加
    diff-match-patch
    intervaltree
    ipython # 新添加
    jedi
    jellyfish # 新添加
    jsonschema # 新添加
    keyring
    nbconvert
    numpydoc
    parso # 新添加
    pexpect # 新添加
    pickleshare # 新添加
    psutil
    pygments
    pylint
    python-lsp-black # 新添加 且依赖  python-lsp-server # Black plugin for the Python LSP Server
    pyls-spyder
    pyqt5 # 新添加
    pyqtwebengine
    python-lsp-server # 版本过低 需要覆盖
    pyxdg
    pyzmq
    qdarkstyle        # 版本过低 需要覆盖 3.0.2
    qstylizer         # 新添加 nixos 没有
    qtawesome
    qtconsole         # 版本过低 需要覆盖 >=5.2.1
    qtpy
    Rtree       # 新添加
    setuptools  # 新添加
    sphinx  # 新添加
    spyder-kernels    # 版本过低 需要覆盖 >=2.2.0,<2.3.0 
    # 下面的包 spyder 源码不需要
    tinycss2  # 新添加
    inflection  # 新添加
    textdistance
    three-merge
    watchdog  # Python API and shell utilities to monitor file system events
    pycodestyle  
    rope 
    numpy 
    scipy 
    matplotlib  
    mccabe 
    pyopengl  # PyOpenGL, the Python OpenGL bindings
    flake8      # Flake8 is a wrapper around pyflakes, pycodestyle and mccabe
    # python-language-server  
    # pyls-black  # Black plugin for the Python Language Server
  ];

  # There is no test for spyder
  doCheck = false;

  desktopItem = makeDesktopItem {
    name = "Spyder";
    exec = "spyder";
    icon = "spyder";
    comment = "Scientific Python Development Environment";
    desktopName = "Spyder";
    genericName = "Python IDE";
    categories = "Development;IDE;";
  };

  postPatch = ''
    # remove dependency on pyqtwebengine
    # this is still part of the pyqt 5.11 version we have in nixpkgs
    # sed -i /pyqtwebengine/d setup.py
    # The major version bump in watchdog is due to changes in supported
    # platforms, not API break.
    # https://github.com/gorakhargosh/watchdog/issues/761#issuecomment-777001518
    substituteInPlace setup.py \
      --replace "pyqt5<5.13" "pyqt5" \
      --replace "pyqtwebengine<5.13" "pyqtwebengine" 
  '';

  postInstall = ''
    # add Python libs to env so Spyder subprocesses
    # created to run compute kernels don't fail with ImportErrors
    wrapProgram $out/bin/spyder --prefix PYTHONPATH : "$PYTHONPATH"
    # Create desktop item
    mkdir -p $out/share/icons
    cp spyder/images/spyder.svg $out/share/icons
    cp -r $desktopItem/share/applications/ $out/share
  '';

  dontWrapQtApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  meta = with lib; {
    description = "Scientific python development environment";
    longDescription = ''
      Spyder (previously known as Pydee) is a powerful interactive development
      environment for the Python language with advanced editing, interactive
      testing, debugging and introspection features.
    '';
    homepage = "https://www.spyder-ide.org/";
    downloadPage = "https://github.com/spyder-ide/spyder/releases";
    changelog = "https://github.com/spyder-ide/spyder/blob/master/CHANGELOG.md";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ gebner ];
  };
}