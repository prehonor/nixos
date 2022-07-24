{ lib
, fetchPypi
, buildPythonPackage
}:


buildPythonPackage rec {
  pname = "whatthepatch";
  version = "1.0.2";
  src = fetchPypi {
    inherit version;
    inherit pname;
    sha256 = "sha256-xUDqWRc+CikeGcdC3YtAbFbivgOaYA7bfG/Drku9+p8=";
  };

  doCheck = false;


  meta = with lib; {
    description = "PyQtChart is is a library for both parsing and applying patch files";
    license = licenses.mit;
    maintainers = with maintainers; [ cscorley ];
    homepage = "https://github.com/cscorley/whatthepatch";
  };
}