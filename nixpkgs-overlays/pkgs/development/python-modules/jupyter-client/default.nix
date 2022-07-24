{ lib
, buildPythonPackage
, fetchPypi
, entrypoints
, jupyter_core
, nest-asyncio
, python-dateutil
, pyzmq
, tornado
, traitlets
, isPyPy
, py
, hatchling
}:

buildPythonPackage rec {
  pname = "jupyter_client";
  version = "7.3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-qppsMgVLKQN0+V9zuwyukUVcWN+4T2XIWRkSuPZebVY=";
  };

  propagatedBuildInputs = [
    entrypoints
    jupyter_core
    nest-asyncio
    python-dateutil
    pyzmq
    tornado
    traitlets
    hatchling
  ] ++ lib.optional isPyPy py;

  format = "pyproject";
  # Circular dependency with ipykernel
  doCheck = false;

  meta = {
    description = "Jupyter protocol implementation and client libraries";
    homepage = "https://jupyter.org/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
  };
}