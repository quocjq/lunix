{ ... }: {
  services = {
    syncthing = {
      enable = true;
      group = "users";
      user = "quocjq";
      dataDir = "/home/quocjq/"; # Default folder for new synced folders
      configDir =
        "/home/quocjq/.config/syncthing"; # Folder for Syncthing's settings and keys
      guiAddress = "0.0.0.0:8384";
      settings = {
        gui = {
          user = "quocjq";
          password = "13172";
        };
        devices = {
          "RMX3085" = {
            id =
              "NLHOU3S-V7OCMQN-GRZJWI4-4LZJJRH-5JB6YKY-V5SWAO6-CYACWDR-CTJEBAN";
          };
        };
        folders = {
          "Storage" = {
            path = "~/Storage";
            devices = [ "RMX3085" ];
          };
        };
      };
    };
  };

}
