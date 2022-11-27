{ lib, stdenv, fetchgit, wayland-scanner }:

stdenv.mkDerivation rec {

/*
  pname = "wlr-protocols";
  version = "unstable-2021-11-01";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "wlroots";
    repo = "wlr-protocols";
    rev = "d998ee6fc64ea7e066014023653d1271b7702c09";
    sha256 = "1vw8b10d1pwsj6f4sr3imvwsy55d3435sp068sj4hdszkxc6axsr";
  };
*/

  name = "wlr-protocols";
  src = fetchgit {
    url = "https://gitlab.freedesktop.org/wlroots/${name}.git";
    rev = "8cdeaac7497f8ba2413e44b421ea00cc47ad828f";
    sha256 = "02xs4zj276sjbk285vxpgcnl72w18wx778smrgh0z89d3kmf7kq9"; 
    deepClone = false;
  };
  strictDeps = true;
  checkInputs = [ wayland-scanner ];

  patchPhase = ''
    substituteInPlace wlr-protocols.pc.in \
      --replace '=''${pc_sysrootdir}' "=" \
      --replace '=@prefix@' "=$out"
    substituteInPlace Makefile \
      --replace 'wlr-output-power-management-v1.xml' 'wlr-output-power-management-unstable-v1.xml'
  '';

  doCheck = true;
  checkPhase = ''
    make check
  '';

  installFlags = [ "DESTDIR=$(out)" "PREFIX=" ];

  meta = with lib; {
    description = "Wayland roots protocol extensions";
    longDescription = ''
      wlr-protocols contains Wayland protocols that add functionality not
      available in the Wayland core protocol, and specific to wlroots-based
      compositors. Such protocols either add completely new functionality, or
      extend the functionality of some other protocol either in Wayland core,
      or some other protocol in wayland-protocols.
    '';
    homepage    = "https://gitlab.freedesktop.org/wlroots/wlr-protocols";
    license     = licenses.mit; # See file headers
    platforms   = platforms.linux;
    maintainers = with maintainers; [ twitchyliquid64 ];
  };
}