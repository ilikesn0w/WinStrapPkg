[![Build](https://github.com/ilikesn0w/WinStrapPkg/actions/workflows/build.yml/badge.svg)](https://github.com/ilikesn0w/WinStrapPkg/actions/workflows/build.yml)
-----
Load SSDT-PCI and apply BUF0 to BUF1 patch before starting Windows booter.

#### How to use?
  Rename `EFI\Microsoft\Boot\bootmgfw.efi` to `rbootmgfw.efi`, then place WinStrap in the same directory and call it bootmgfw.efi

  Rename `EFI\Boot\BOOTX64.efi` to `RBOOTX64.efi`, then place WinStrap in the same directory and call it BOOTX64.efi
  > [!WARNING]
  > Replace BOOTX64.efi **only** if you know that there are no other bootloaders on this ESP partition

  If present rename `EFI\Microsoft\Boot\cdboot.efi` to `rcdboot.efi`, then place WinStrap in the same directory and call it cdboot.efi

  The SSDT is built into the bin, so there's no need to place it anywhere separately.

  Also, keep in mind that newer versions of Windows sometimes update the booter, so if you lose sound after an update, you’ll need to repeat the steps above.
  > [!CAUTION]
  >  This **cannot** be used on a Mac Pro, since I didn’t implement SecureBoot protection, and Windows could update the booter at any time.

#### Credits

- [Acidanthera](https://github.com/acidanthera), The HermitCrabs Lab and contributors for [OpenCorePkg](https://github.com/acidanthera/OpenCorePkg)
- [Dortania](https://github.com/dortania) for [SSDT-PCI.aml](https://github.com/dortania/OpenCore-Legacy-Patcher/blob/main/payloads/ACPI/SSDT-PCI.aml) and [BUF0 to BUF1 patch](https://github.com/dortania/OpenCore-Legacy-Patcher/blob/main/payloads/Config/config.plist#L138-#L165)
- [Apple](https://www.apple.com/) for Apple EFI
