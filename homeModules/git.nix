{ ... }: {
  programs.git = { 
    enable = true;
    userName = "AndrezHP";
    userEmail = "usermail@mail.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };
}
