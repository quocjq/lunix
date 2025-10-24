{ config, ... }: {
  # Add utility functions here
  mkSymlink = path: {
    source = config.lib.file.mkOutOfStoreSymlink path;
    recursive = true;
  };
}
