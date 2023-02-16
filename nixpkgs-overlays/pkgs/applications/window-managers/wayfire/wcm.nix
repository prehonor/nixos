{ stdenv, lib, fetchgit, cmake, meson, ninja, pkg-config, wayland, wrapGAppsHook
, gtk3, libevdev, libepoxy, libxml2, wayfire, wayland-protocols, wf-config, wf-shell, wlroots
}:
let
  source = {
    stable = {
      version = "0.7.5";
      rev = "5a82f0a0c76c7878f8a5e78dd02dc563202547a0";
      sha256 = "sha256-ZImg1oQ2ly6ExaJ+sK1BPUzmhj7sy5cGRVjNszFXYMs=";
    };
    master = {
      version = "0.8.0";
      rev = "09511f10020c9d7ea5a50d1dd2927c6669595a9c";
      sha256 = "sha256-ZImg1oQ2ly6ExaJ+sK1BPUzmhj7sy5cGRVjNszFXYMs=";
    };
  };
in
stdenv.mkDerivation rec {

  pname = "wcm";
  inherit (source.stable) version;
  
  src = fetchgit {
    url = "https://gitee.com/github-10784632_admin_admin/${pname}.git";
    inherit (source.stable) rev sha256;
    fetchSubmodules = true;
  };
  dontUseCmakeConfigure = true;
  nativeBuildInputs = [ cmake meson ninja pkg-config wayland wrapGAppsHook ];
  buildInputs = [
    gtk3 libevdev libxml2 wayfire wayland libepoxy
    wayland-protocols wf-config wf-shell wlroots
  ];

  meta = with lib; {
    homepage = "https://github.com/WayfireWM/wcm";
    description = "Wayfire Config Manager";
    license = licenses.mit;
    maintainers = with maintainers; [ qyliss wucke13 ];
    platforms = platforms.unix;
  };
}
