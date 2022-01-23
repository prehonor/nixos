{ lib
, python3Packages
, fetchFromGitHub
}:

python3Packages.buildPythonApplication rec {
  pname = "Fildem";
  version = "0.6.7";


  src = fetchFromGitHub {
    owner = "gonzaarcr";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-cKEFTF8DnQIQAXVW9NvE34mUqueQP/OtxTzMUy1dT5U=";
  };

  propagatedBuildInputs = with python3Packages; [ pygobject3 ];

  doCheck = false;

  meta = {
    description = "gnome 插件Fildem 的python部分";
    homepage = "https://github.com/gonzaarcr/Fildem";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ gonzaarcr ];
  };
}