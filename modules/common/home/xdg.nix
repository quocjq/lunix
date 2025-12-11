{ ... }:
{
  xdg = {
    enable = true;
    mime.enable = true;
    mimeApps = {
      enable = true;
    };
    portal = {
      enable = true;
      config.common.default = "*";
    };
  };

}
