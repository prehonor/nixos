{ stdenv, lib, fetchFromGitHub, cmake, meson, ninja, pkg-config
, doctest, glm, libevdev, libxml2
}:

stdenv.mkDerivation rec {
/*
  pname = "wf-config";
  version = "0.7.1";

  src = fetchurl {
    url = "https://github.com/WayfireWM/wf-config/releases/download/v${version}/wf-config-${version}.tar.xz";
    sha256 = "1w75yxhz0nvw4mlv38sxp8k8wb5h99b51x3fdvizc3yaxanqa8kx";
  };
  */
  # url = "https://github.com/WayfireWM/${name}.git";
  pname = "wf-config";
  version = "0.8.0";
  src = fetchFromGitHub {
    owner = "WayfireWM";
    repo = "${pname}";
    rev = "e42a3870fb194842a505ad5a9671be1aebda0b0b";
    sha256 = "0n6i3hizbqixxjh33950ya8avwqil5k94jbgff1pimcbh9ahpgrr"; 
  };
  nativeBuildInputs = [ cmake meson ninja pkg-config ];
  buildInputs = [ doctest libevdev libxml2 ];
  propagatedBuildInputs = [ glm ];

  # CMake is just used for finding doctest.
  dontUseCmakeConfigure = true;

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/WayfireWM/wf-config";
    description = "Library for managing configuration files, written for Wayfire";
    license = licenses.mit;
    maintainers = with maintainers; [ qyliss wucke13 ];
    platforms = platforms.unix;
  };
}
