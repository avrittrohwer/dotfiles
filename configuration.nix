# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Make the LUKS encrypted partion be known
  boot.initrd.luks.devices = [
    {
      name = "root";
      device = "/dev/nvme0n1p2";
      preLVM = true;
    }
  ];

  networking.hostName = "lloyd"; # Define your hostname.
  networking.networkmanager.enable = true;  # Enables wireless support via network manager
  services.gnome3.gnome-keyring.enable = true; # Enables gnome to auto-connect to wifi

  # Enable auto upgrades
  system.autoUpgrade.enable = true;

  # Enable auto garbage collection
  nix.gc.automatic = true;

  # Set your time zone.
  time.timeZone = "America/Detroit";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    home-manager
    gnome3.gnome-tweaks
    gnomeExtensions.caffeine
    gnomeExtensions.nohotcorner
  ];

  # List services that you want to enable:

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Configure xserver
  services.xserver = {
    enable = true;
    layout = "us";
    xkbOptions = "ctrl:nocaps"; # remap capslock to control

    # Touchpad settings
    libinput = {
      enable = true;
      disableWhileTyping = true;
    };

    # Use gnome
    displayManager.gdm.enable = true;
    desktopManager.gnome3.enable = true;
  };

  # Enable fish shell
  programs.fish.enable = true;

  # Configure users
  users.users.avritt = {
    isNormalUser = true;
    home = "/home/avritt";
    shell = "/run/current-system/sw/bin/fish";
    extraGroups = [ "wheel" "networkmanager" ];
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.03"; # Did you read the comment?
}
