{ newScope, wayfire }:

let
  self = with self; {
    inherit wayfire;

    callPackage = newScope self;

    wf-shell = callPackage ./wf-shell.nix { };
    wf-info = callPackage ./wf-info.nix { };
    wayfire-plugin_dbus_interface = callPackage ./wayfire-plugin_dbus_interface.nix { };
    wayfire-plugins-extra = callPackage ./wayfire-plugins-extra.nix { }; 

  };
in
self
