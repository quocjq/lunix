{ config, pkgs, lib, ... }: {

  # Make helper functions available at lib level so they can be used without let...in
  lib = {
    mkSym = path: {
      source = config.lib.file.mkOutOfStoreSymlink path;
      recursive = true;
    };

    mkSymlink = path: {
      source = config.lib.file.mkOutOfStoreSymlink path;
      recursive = true;
    };
  };

}
