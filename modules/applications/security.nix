{ config, lib, pkgs, ... }:

{
  # 1Password password manager
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    # Certain features, including CLI integration and system authentication support,
    # require enabling PolKit integration on some desktop environments (e.g. Plasma).
    polkitPolicyOwners = [ "ben" ];
  };

  # Security-related packages
  environment.systemPackages = with pkgs; [
    _1password-gui
    _1password-cli
    veracrypt # Disk encryption utility
  ];
}
