{ config, lib, pkgs, ... }:

{
  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    extraPackages = [ pkgs.mesa.drivers ];

    ## radv: an open-source Vulkan driver from freedesktop
    # The default driver, works well with AMD GPUs

    ## amdvlk: an open-source Vulkan driver from AMD
    # Uncomment these lines to use amdvlk instead:
    # extraPackages = [ pkgs.amdvlk ];
    # extraPackages32 = [ pkgs.driversi686Linux.amdvlk ];
  };
}
