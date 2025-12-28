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

      kernelParams = [
        # enable IOMMU
        "amd_iommu=on"
        # isolate the GPU
        ("vfio-pci.ids=" + lib.concatStringsSep "," gpuIDs)
      ];
    };

    hardware.opengl.enable = true;
    virtualisation.spiceUSBRedirection.enable = true;
  };
}
