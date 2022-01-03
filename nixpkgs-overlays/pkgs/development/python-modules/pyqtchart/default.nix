{ lib
, qmake
, pkg-config
, qtcharts
, qtbase
, buildPythonPackage
, isPy27
, sip
, pyqt5
, python
, fetchPypi
, pyqt-builder
, pyqtchart-qt
}:


buildPythonPackage rec {
  pname = "PyQtChart";
  version = qtcharts.version;
  src = fetchPypi {
    inherit version;
    inherit pname;
    sha256 = "1kxwhkp4mwrhdcfbcqimrhqhiglzsrr2c6mfqr60vralk9ld0m2z";
  };
  format = "pyproject";

  # disabled = !isPy27;

  nativeBuildInputs = [ sip pkg-config qmake qtbase qtcharts pyqt-builder ];
  buildInputs = [ sip qtcharts qtbase ];
  propagatedBuildInputs = [ pyqt-builder pyqtchart-qt pyqt5 ];

  dontWrapQtApps = true;

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "[tool.sip.project]" "[tool.sip.project]''\nsip-include-dirs = [\"${pyqt5}/${python.sitePackages}/PyQt5/bindings\"]"
  '';


  postInstall = ''
    # Needed by pythonImportsCheck to find the module
    export PYTHONPATH="$out/${python.sitePackages}:$PYTHONPATH"
  '';


  # Avoid running qmake, which is in nativeBuildInputs
  dontConfigure = true;

  # Checked using pythonImportsCheck
  doCheck = false;


  enableParallelBuilding = true;

  pythonImportsCheck = [ 
    "PyQt5.QtChart"
  ];

  meta = with lib; {
    description = "PyQtChart is a set of Python bindings for The Qt Company’s Qt Charts library. The bindings sit on top of PyQt5 and are implemented as a single module";
    license = licenses.lgpl3;
    maintainers = with maintainers; [  Riverbank_Computing ];
    homepage = "https://www.riverbankcomputing.com/software/pyqtchart/";
  };
}