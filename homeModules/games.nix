{pkgs, ...}: {
  home.packages = with pkgs; [
    wine
    steam
    steam-run
    runelite
    lutris-unwrapped
    bottles-unwrapped
    heroic-unwrapped
  ];
}
