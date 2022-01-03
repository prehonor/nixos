{ lib
, fetchPypi
, buildPythonPackage
, autoPatchelfHook
, libGL
, full
, stdenv
}:

buildPythonPackage rec {
  pname = "PyQtChart_Qt";
  version = "5.15.2";
  format = "wheel";
  
  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [ libGL full libGL stdenv.cc.cc.lib ];
  

  src = fetchPypi {
    inherit version pname format;
    platform = "manylinux2014_x86_64";
    dist = "py3";
    python = "py3";
    sha256 = "1xryvhff72l1j5a90pmnqjijmvnzddlfdcpvvql9i8v8rc6a41zr";
  };


  postPatch = ''

  '';

  meta = with lib; {
    description = "This package contains the subset of a Qt installation that is required by PyQtChart";
    homepage = "https://www.riverbankcomputing.com/software/pyqt/";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ Riverbank_Computing ];
  };
}