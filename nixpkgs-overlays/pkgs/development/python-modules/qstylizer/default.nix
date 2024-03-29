{ lib
, fetchFromGitHub
, buildPythonPackage
, sphinx
, sphinx_rtd_theme
, tinycss2
, inflection
, pbr
}:

buildPythonPackage rec {
  pname = "qstylizer";
  version = "0.2.1";


  # 解决pbr问题
  # https://stackoverflow.com/questions/58854822/python-setup-py-sdist-error-versioning-for-this-project-requires-either-an-sdist
  # Manually set version because prb wants to get it from the git
  # upstream repository (and we are installing from tarball instead)
  PBR_VERSION = version;


  src = fetchFromGitHub {
    owner = "blambright";
    repo = pname;
    rev = version;
    sha256 = "1zgnbbnr0qpbp07mj90rwppl27lralxg6knzdppf705xjh332hw8"; 

  };

/*
  src = fetchgit {
    url = "https://github.com/blambright/qstylizer.git";
    rev = version;
    sha256 = "1zgnbbnr0qpbp07mj90rwppl27lralxg6knzdppf705xjh332hw8";
    leaveDotGit = true;
  };
  */
  # No tests available
  doCheck = false;
  nativeBuildInputs = [
    pbr
  ];
  propagatedBuildInputs = [ 
    sphinx 
    sphinx_rtd_theme 
    tinycss2 
    inflection
  ];

  meta = with lib; {
    description = "qstylizer is a python package designed to help with the construction of PyQt/PySide stylesheets";
    homepage = "https://github.com/blambright/qstylizer";
    license = licenses.mit;
    maintainers = with maintainers; [ blambright ];
  };
}