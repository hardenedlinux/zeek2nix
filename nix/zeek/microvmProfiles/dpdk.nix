{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  options = {
    boot.hugepages.size = mkOption {
      type = types.enum ["1GB" "2MB"];
      description = ''
        Size of one hugetable
      '';
      default = "2MB";
    };
    boot.hugepages.number = mkOption {
      type = types.int;
      description = ''
        Nr of hugepages
      '';
      default = 1000;
    };
  };
  config = {
    environment.systemPackages = [pkgs.dpdk];
    nixpkgs.config.allowBroken = true;
    boot.kernelParams = [
      # spdk/dpdk hugepages
      "default_hugepagesz=${config.boot.hugepages.size}"
      "hugepagesz=${config.boot.hugepages.size}"
      "hugepages=${toString config.boot.hugepages.number}"
      # "intel_iommu=on"
      # "iommu=pt"
    ];
    boot.extraModulePackages = [
      (config.boot.kernelPackages.dpdk-kmods.overrideAttrs (oldAttrs: {
        src = pkgs.fetchzip {
          url = "https://git.dpdk.org/dpdk-kmods/snapshot/dpdk-kmods-e68a705cc5dc3d1333bbcd722fe4e9a6ba3ee648.zip";
          sha256 = "sha256-kgaCmw0mGeXAuLGekuEk3AfMm5sD3CtrSQJO4H7TJno=";
        };
      }))
      # config.boot.kernelPackages.dpdk-kmods
    ];
    # https://stackoverflow.com/questions/37626041/using-dpdk-kernel-nic-interface-in-a-virtualized-environment
    boot.kernelModules = ["igb_uio" "vfio-pci" "uio_pci_generic" "kvm-intel"];
    boot.extraModprobeConfig = ''
      blacklist ice
    '';
  };
}
