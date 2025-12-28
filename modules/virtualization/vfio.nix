let
  gpuIDs = [
    "1002:744c" # 7900 XTX Video
    "1002:ab30" # 7900 XTX Audio
  ];
in { pkgs, lib, config, ... }: {
  options.vfio.enable = with lib;
    mkEnableOption "Configure the machine for VFIO";

  config = lib.mkIf config.vfio.enable {
    boot = {
      initrd.kernelModules = [
        "vfio_pci"
        "vfio"
        "vfio_iommu_type1"

        # Keep this after the VFIO modules: order matters
        "amdgpu"
      ];

      # Kernel 6.0+ requires modprobe configuration for vfio-pci binding
      # The kernel parameter method (vfio-pci.ids=) is no longer sufficient
      extraModprobeConfig = ''
        # Force vfio-pci to load before amdgpu to prevent race condition
        softdep amdgpu pre: vfio-pci
        # Bind discrete GPU to vfio-pci (replaces vfio-pci.ids= kernel param)
        options vfio-pci ids=${lib.concatStringsSep "," gpuIDs}
      '';
    };

    hardware.opengl.enable = true;
    virtualisation.spiceUSBRedirection.enable = true;
  };
}
