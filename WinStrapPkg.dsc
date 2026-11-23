## @file
# Load SSDT-PCI and apply BUF0 to BUF1 patch before starting Windows booter.
#
# Copyright (c) 2026, ilikesn0w. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# 3. Neither the name of the copyright holder nor the names of its
#    contributors may be used to endorse or promote products derived from
#    this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
##

[Defines]
  PLATFORM_NAME           = WinStrapPkg
  PLATFORM_GUID           = C503FCCF-A799-4B1B-800B-DDCF8F7ECCC2
  PLATFORM_VERSION        = 1.0
  SUPPORTED_ARCHITECTURES = X64|IA32
  BUILD_TARGETS           = RELEASE|DEBUG|NOOPT
  SKUID_IDENTIFIER        = DEFAULT
  DSC_SPECIFICATION       = 0x0001001C

!include MdePkg/MdeLibs.dsc.inc

[LibraryClasses]
  BaseLib|MdePkg/Library/BaseLib/BaseLib.inf
  # We cannot use BaseMemoryLibOptDxe since it uses SSE instructions,
  # and some types of firmware fail to properly maintain MMX register contexts
  # across the timers. This results in exceptions when trying to execute
  # primitives like CopyMem in timers (e.g. AIKDataWriteEntry).
  # Reproduced on ASUS M5A97 with AMD FX8320 CPU.
  # REF: https://github.com/acidanthera/bugtracker/issues/754
  BaseMemoryLib|MdePkg/Library/BaseMemoryLibRepStr/BaseMemoryLibRepStr.inf
  BaseOverflowLib|MdePkg/Library/BaseOverflowLib/BaseOverflowLib.inf
  BaseRngLib|MdePkg/Library/BaseRngLib/BaseRngLib.inf
  BcfgCommandLib|ShellPkg/Library/UefiShellBcfgCommandLib/UefiShellBcfgCommandLib.inf
  CacheMaintenanceLib|MdePkg/Library/BaseCacheMaintenanceLib/BaseCacheMaintenanceLib.inf
  CpuLib|MdePkg/Library/BaseCpuLib/BaseCpuLib.inf
  DebugLib|OpenCorePkg/Library/OcDebugLibProtocol/OcDebugLibProtocol.inf
  DxeServicesLib|MdePkg/Library/DxeServicesLib/DxeServicesLib.inf
  MtrrLib|UefiCpuPkg/Library/MtrrLib/MtrrLib.inf
  DebugPrintErrorLevelLib|MdePkg/Library/BaseDebugPrintErrorLevelLib/BaseDebugPrintErrorLevelLib.inf
  DevicePathLib|MdePkg/Library/UefiDevicePathLib/UefiDevicePathLib.inf
  DxeServicesTableLib|MdePkg/Library/DxeServicesTableLib/DxeServicesTableLib.inf
  FileHandleLib|MdePkg/Library/UefiFileHandleLib/UefiFileHandleLib.inf
  VirtioLib|OvmfPkg/Library/VirtioLib/VirtioLib.inf
  FrameBufferBltLib|MdeModulePkg/Library/FrameBufferBltLib/FrameBufferBltLib.inf
  HandleParsingLib|ShellPkg/Library/UefiHandleParsingLib/UefiHandleParsingLib.inf
  OrderedCollectionLib|MdePkg/Library/BaseOrderedCollectionRedBlackTreeLib/BaseOrderedCollectionRedBlackTreeLib.inf
  HiiLib|MdeModulePkg/Library/UefiHiiLib/UefiHiiLib.inf
  HobLib|MdePkg/Library/DxeHobLib/DxeHobLib.inf
  IoLib|MdePkg/Library/BaseIoLibIntrinsic/BaseIoLibIntrinsic.inf
  MemoryAllocationLib|MdePkg/Library/UefiMemoryAllocationLib/UefiMemoryAllocationLib.inf
  OcAcpiLib|OpenCorePkg/Library/OcAcpiLib/OcAcpiLib.inf
  OcAfterBootCompatLib|OpenCorePkg/Library/OcAfterBootCompatLib/OcAfterBootCompatLib.inf
  OcApfsLib|OpenCorePkg/Library/OcApfsLib/OcApfsLib.inf
  OcAppleBootPolicyLib|OpenCorePkg/Library/OcAppleBootPolicyLib/OcAppleBootPolicyLib.inf
  OcAppleChunklistLib|OpenCorePkg/Library/OcAppleChunklistLib/OcAppleChunklistLib.inf
  OcAppleDiskImageLib|OpenCorePkg/Library/OcAppleDiskImageLib/OcAppleDiskImageLib.inf
  OcAppleEventLib|OpenCorePkg/Library/OcAppleEventLib/OcAppleEventLib.inf
  OcAppleFirmwarePasswordLib|OpenCorePkg/Library/OcAppleFirmwarePasswordLib/OcAppleFirmwarePasswordLib.inf
  OcAppleImageConversionLib|OpenCorePkg/Library/OcAppleImageConversionLib/OcAppleImageConversionLib.inf
  OcAppleImg4Lib|OpenCorePkg/Library/OcAppleImg4Lib/OcAppleImg4Lib.inf
  OcAppleKernelLib|OpenCorePkg/Library/OcAppleKernelLib/OcAppleKernelLib.inf
  OcAppleKeyMapLib|OpenCorePkg/Library/OcAppleKeyMapLib/OcAppleKeyMapLib.inf
  OcAppleKeysLib|OpenCorePkg/Library/OcAppleKeysLib/OcAppleKeysLib.inf
  OcAppleRamDiskLib|OpenCorePkg/Library/OcAppleRamDiskLib/OcAppleRamDiskLib.inf
  OcAppleSecureBootLib|OpenCorePkg/Library/OcAppleSecureBootLib/OcAppleSecureBootLib.inf
  OcAppleUserInterfaceThemeLib|OpenCorePkg/Library/OcAppleUserInterfaceThemeLib/OcAppleUserInterfaceThemeLib.inf
  OcAudioLib|OpenCorePkg/Library/OcAudioLib/OcAudioLib.inf
  OcBlitLib|OpenCorePkg/Library/OcBlitLib/OcBlitLib.inf
  OcBootManagementLib|OpenCorePkg/Library/OcBootManagementLib/OcBootManagementLib.inf
  OcBootServicesTableLib|OpenCorePkg/Library/OcBootServicesTableLib/OcBootServicesTableLib.inf
  OcCompressionLib|OpenCorePkg/Library/OcCompressionLib/OcCompressionLib.inf
  OcConfigurationLib|OpenCorePkg/Library/OcConfigurationLib/OcConfigurationLib.inf
  OcConsoleControlEntryModeGenericLib|OpenCorePkg/Library/OcConsoleControlEntryModeLib/OcConsoleControlEntryModeGenericLib.inf
  OcConsoleControlEntryModeLocalLib|OpenCorePkg/Library/OcConsoleControlEntryModeLib/OcConsoleControlEntryModeLocalLib.inf
  OcConsoleLib|OpenCorePkg/Library/OcConsoleLib/OcConsoleLib.inf
  OcCpuLib|OpenCorePkg/Library/OcCpuLib/OcCpuLib.inf
  OcCryptoLib|OpenCorePkg/Library/OcCryptoLib/OcCryptoLib.inf
  OcDataHubLib|OpenCorePkg/Library/OcDataHubLib/OcDataHubLib.inf
  OcDeviceMiscLib|OpenCorePkg/Library/OcDeviceMiscLib/OcDeviceMiscLib.inf
  OcDevicePathLib|OpenCorePkg/Library/OcDevicePathLib/OcDevicePathLib.inf
  OcDevicePropertyLib|OpenCorePkg/Library/OcDevicePropertyLib/OcDevicePropertyLib.inf
  OcDeviceTreeLib|OpenCorePkg/Library/OcDeviceTreeLib/OcDeviceTreeLib.inf
  OcDirectResetLib|OpenCorePkg/Library/OcDirectResetLib/OcDirectResetLib.inf
  OcDriverConnectionLib|OpenCorePkg/Library/OcDriverConnectionLib/OcDriverConnectionLib.inf
  OcFileLib|OpenCorePkg/Library/OcFileLib/OcFileLib.inf
  OcFirmwareVolumeLib|OpenCorePkg/Library/OcFirmwareVolumeLib/OcFirmwareVolumeLib.inf
  OcFlexArrayLib|OpenCorePkg/Library/OcFlexArrayLib/OcFlexArrayLib.inf
  OcGuardLib|OpenCorePkg/Library/OcGuardLib/OcGuardLib.inf
  OcHashServicesLib|OpenCorePkg/Library/OcHashServicesLib/OcHashServicesLib.inf
  OcHdaDevicesLib|OpenCorePkg/Library/OcHdaDevicesLib/OcHdaDevicesLib.inf
  OcHeciLib|OpenCorePkg/Library/OcHeciLib/OcHeciLib.inf
  OcHiiDatabaseLocalLib|OpenCorePkg/Library/OcHiiDatabaseLib/OcHiiDatabaseLocalLib.inf
  OcInputLib|OpenCorePkg/Library/OcInputLib/OcInputLib.inf
  OcLegacyThunkLib|OpenCorePkg/Library/OcLegacyThunkLib/OcLegacyThunkLib.inf
  OcLogAggregatorLib|OpenCorePkg/Library/OcLogAggregatorLib/OcLogAggregatorLib.inf
  OcMachoLib|OpenCorePkg/Library/OcMachoLib/OcMachoLib.inf
  OcMacInfoLib|OpenCorePkg/Library/OcMacInfoLib/OcMacInfoLib.inf
  OcMainLib|OpenCorePkg/Library/OcMainLib/OcMainLib.inf
  OcMemoryLib|OpenCorePkg/Library/OcMemoryLib/OcMemoryLib.inf
  OcMiscLib|OpenCorePkg/Library/OcMiscLib/OcMiscLib.inf
  OcMp3Lib|OpenCorePkg/Library/OcMp3Lib/OcMp3Lib.inf
  OcOSInfoLib|OpenCorePkg/Library/OcOSInfoLib/OcOSInfoLib.inf
  OcPciIoLib|OpenCorePkg/Library/OcPciIoLib/OcPciIoLib.inf
  OcPngLib|OpenCorePkg/Library/OcPngLib/OcPngLib.inf
  OcRngLib|OpenCorePkg/Library/OcRngLib/OcRngLib.inf
  OcRtcLib|OpenCorePkg/Library/OcRtcLib/OcRtcLib.inf
  OcSerializeLib|OpenCorePkg/Library/OcSerializeLib/OcSerializeLib.inf
  OcSmbiosLib|OpenCorePkg/Library/OcSmbiosLib/OcSmbiosLib.inf
  OcSmcLib|OpenCorePkg/Library/OcSmcLib/OcSmcLib.inf
  OcStorageLib|OpenCorePkg/Library/OcStorageLib/OcStorageLib.inf
  OcStringLib|OpenCorePkg/Library/OcStringLib/OcStringLib.inf
  OcTemplateLib|OpenCorePkg/Library/OcTemplateLib/OcTemplateLib.inf
  OcTypingLib|OpenCorePkg/Library/OcTypingLib/OcTypingLib.inf
  TimerLib|OpenCorePkg/Library/OcTimerLib/OcTimerLib.inf
  OcUnicodeCollationEngGenericLib|OpenCorePkg/Library/OcUnicodeCollationEngLib/OcUnicodeCollationEngGenericLib.inf
  OcUnicodeCollationEngLocalLib|OpenCorePkg/Library/OcUnicodeCollationEngLib/OcUnicodeCollationEngLocalLib.inf
  OcVirtualFsLib|OpenCorePkg/Library/OcVirtualFsLib/OcVirtualFsLib.inf
  OcWaveLib|OpenCorePkg/Library/OcWaveLib/OcWaveLib.inf
  OcXmlLib|OpenCorePkg/Library/OcXmlLib/OcXmlLib.inf
  OcPeCoffExtLib|OpenCorePkg/Library/OcPeCoffExtLib/OcPeCoffExtLib.inf
  OcVariableLib|OpenCorePkg/Library/OcVariableLib/OcVariableLib.inf
  OcVariableRuntimeLib|OpenCorePkg/Library/OcVariableRuntimeLib/OcVariableRuntimeLib.inf
  PcdLib|MdePkg/Library/BasePcdLibNull/BasePcdLibNull.inf
  PciCf8Lib|MdePkg/Library/BasePciCf8Lib/BasePciCf8Lib.inf
  PciCapLib|OvmfPkg/Library/BasePciCapLib/BasePciCapLib.inf
  PciCapPciIoLib|OvmfPkg/Library/UefiPciCapPciIoLib/UefiPciCapPciIoLib.inf
  PciLib|MdePkg/Library/BasePciLibCf8/BasePciLibCf8.inf
  PeCoffLib2|MdePkg/Library/BasePeCoffLib2/BasePeCoffLib2.inf
  PerformanceLib|MdePkg/Library/BasePerformanceLibNull/BasePerformanceLibNull.inf
  PlatformHookLib|MdeModulePkg/Library/BasePlatformHookLibNull/BasePlatformHookLibNull.inf
  PrintLib|MdePkg/Library/BasePrintLib/BasePrintLib.inf
  ReportStatusCodeLib|MdePkg/Library/BaseReportStatusCodeLibNull/BaseReportStatusCodeLibNull.inf
  SerialPortLib|MdeModulePkg/Library/BaseSerialPortLib16550/BaseSerialPortLib16550.inf
  ShellCommandLib|ShellPkg/Library/UefiShellCommandLib/UefiShellCommandLib.inf
  ShellLib|ShellPkg/Library/UefiShellLib/UefiShellLib.inf
  SortLib|MdeModulePkg/Library/UefiSortLib/UefiSortLib.inf
  SynchronizationLib|MdePkg/Library/BaseSynchronizationLib/BaseSynchronizationLib.inf
  UefiApplicationEntryPoint|OpenCorePkg/Library/OcApplicationEntryPoint/UefiApplicationEntryPoint.inf
  UefiBootServicesTableLib|MdePkg/Library/UefiBootServicesTableLib/UefiBootServicesTableLib.inf
  UefiBootManagerLib|MdeModulePkg/Library/UefiBootManagerLib/UefiBootManagerLib.inf
  UefiDriverEntryPoint|OpenCorePkg/Library/OcDriverEntryPoint/UefiDriverEntryPoint.inf
  UefiHiiServicesLib|OpenCorePkg/Library/OcHiiServicesLib/OcHiiServicesLib.inf
  UefiImageExtraActionLib|MdePkg/Library/BaseUefiImageExtraActionLibNull/BaseUefiImageExtraActionLibNull.inf
  UefiLib|MdePkg/Library/UefiLib/UefiLib.inf
  UefiRuntimeServicesTableLib|MdePkg/Library/UefiRuntimeServicesTableLib/UefiRuntimeServicesTableLib.inf
  UefiUsbLib|MdePkg/Library/UefiUsbLib/UefiUsbLib.inf
  VariablePolicyHelperLib|MdeModulePkg/Library/VariablePolicyHelperLib/VariablePolicyHelperLib.inf
  VariableFlashInfoLib|MdeModulePkg/Library/BaseVariableFlashInfoLib/BaseVariableFlashInfoLib.inf
  ResetSystemLib|OpenCorePkg/Library/OcResetSystemLib/OcResetSystemLib.inf

[Components]
  WinStrapPkg/Application/WinStrap/WinStrap.inf

[LibraryClasses]
  NULL|MdePkg/Library/IntrinsicLib/IntrinsicLib.inf

[PcdsFixedAtBuild]
  gEfiMdePkgTokenSpaceGuid.PcdMaximumAsciiStringLength|0
!if $(TARGET) == RELEASE
  # DEBUG_PRINT_ENABLED
  gEfiMdePkgTokenSpaceGuid.PcdDebugPropertyMask|2
  # DEBUG_ERROR | DEBUG_WARN
  gEfiMdePkgTokenSpaceGuid.PcdDebugPrintErrorLevel|0x80000002
  gEfiMdePkgTokenSpaceGuid.PcdFixedDebugPrintErrorLevel|0x80000002
!else
  # DEBUG_ASSERT_ENABLED | DEBUG_PRINT_ENABLED | DEBUG_CODE_ENABLED | CLEAR_MEMORY_ENABLED | ASSERT_DEADLOOP_ENABLED
  gEfiMdePkgTokenSpaceGuid.PcdDebugPropertyMask|0x2f
  # DEBUG_ERROR | DEBUG_WARN | DEBUG_INFO
  gEfiMdePkgTokenSpaceGuid.PcdDebugPrintErrorLevel|0x80000042
  gEfiMdePkgTokenSpaceGuid.PcdFixedDebugPrintErrorLevel|0x80000042
!endif
  gOpenCorePkgTokenSpaceGuid.PcdCanaryAllowRdtscFallback|TRUE

  # ImageLoader settings
  gEfiMdePkgTokenSpaceGuid.PcdImageLoaderRtRelocAllowTargetMismatch|FALSE
  gEfiMdePkgTokenSpaceGuid.PcdImageLoaderHashProhibitOverlap|TRUE
  gEfiMdePkgTokenSpaceGuid.PcdImageLoaderLoadHeader|TRUE
  gEfiMdePkgTokenSpaceGuid.PcdImageLoaderDebugSupport|FALSE
  gEfiMdePkgTokenSpaceGuid.PcdImageLoaderAllowMisalignedOffset|FALSE
  gEfiMdePkgTokenSpaceGuid.PcdImageLoaderRemoveXForWX|TRUE
  gEfiMdePkgTokenSpaceGuid.PcdImageLoaderWXorX|TRUE
  gEfiMdePkgTokenSpaceGuid.PcdImageLoaderAlignmentPolicy|0xFFFFFFFF
  gEfiMdePkgTokenSpaceGuid.PcdImageLoaderRelocTypePolicy|0xFFFFFFFF
  gEfiMdePkgTokenSpaceGuid.PcdImageProtectionPolicy|0x00000003

[PcdsPatchableInModule]
  gEfiMdeModulePkgTokenSpaceGuid.PcdSerialRegisterAccessWidth|8
  gEfiMdeModulePkgTokenSpaceGuid.PcdSerialUseMmio|FALSE
  gEfiMdeModulePkgTokenSpaceGuid.PcdSerialUseHardwareFlowControl|FALSE
  gEfiMdeModulePkgTokenSpaceGuid.PcdSerialDetectCable|FALSE
  gEfiMdeModulePkgTokenSpaceGuid.PcdSerialRegisterBase|0x03F8
  gEfiMdeModulePkgTokenSpaceGuid.PcdSerialBaudRate|115200
  gEfiMdeModulePkgTokenSpaceGuid.PcdSerialLineControl|0x03
  gEfiMdeModulePkgTokenSpaceGuid.PcdSerialFifoControl|0x07
  gEfiMdeModulePkgTokenSpaceGuid.PcdSerialClockRate|1843200
  gEfiMdeModulePkgTokenSpaceGuid.PcdSerialPciDeviceInfo|{0xFF,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
  gEfiMdeModulePkgTokenSpaceGuid.PcdSerialExtendedTxFifoSize|64
  gEfiMdeModulePkgTokenSpaceGuid.PcdSerialRegisterStride|1

[BuildOptions]
  # While there are no PCDs as of now, there at least are some custom macros.
  DEFINE OCPKG_BUILD_OPTIONS_GEN = -D DISABLE_NEW_DEPRECATED_INTERFACES $(OCPKG_BUILD_OPTIONS) -D OC_TARGET_$(TARGET)=1
  DEFINE OCPKG_ANAL_OPTIONS_GEN = "-DANALYZER_UNREACHABLE=__builtin_unreachable" "-DANALYZER_NORETURN=__attribute__((noreturn))"

  GCC:DEBUG_*_*_CC_FLAGS        = $(OCPKG_BUILD_OPTIONS_GEN) $(OCPKG_ANAL_OPTIONS_GEN) -fstack-protector-strong -mstack-protector-guard=global -Wuninitialized
  GCC:NOOPT_*_*_CC_FLAGS        = $(OCPKG_BUILD_OPTIONS_GEN) $(OCPKG_ANAL_OPTIONS_GEN) -fstack-protector-strong -mstack-protector-guard=global -Wuninitialized
  GCC:RELEASE_*_*_CC_FLAGS      = $(OCPKG_BUILD_OPTIONS_GEN) $(OCPKG_ANAL_OPTIONS_GEN) -fstack-protector-strong -mstack-protector-guard=global -Wuninitialized
  CLANGPDB:DEBUG_*_*_CC_FLAGS   = $(OCPKG_BUILD_OPTIONS_GEN) $(OCPKG_ANAL_OPTIONS_GEN) -fstack-protector-strong -mstack-protector-guard=global -ftrivial-auto-var-init=pattern
  CLANGPDB:NOOPT_*_*_CC_FLAGS   = $(OCPKG_BUILD_OPTIONS_GEN) $(OCPKG_ANAL_OPTIONS_GEN) -fstack-protector-strong -mstack-protector-guard=global -ftrivial-auto-var-init=pattern
  CLANGPDB:RELEASE_*_*_CC_FLAGS = $(OCPKG_BUILD_OPTIONS_GEN) $(OCPKG_ANAL_OPTIONS_GEN) -fstack-protector-strong -mstack-protector-guard=global -ftrivial-auto-var-init=pattern
  CLANGGCC:DEBUG_*_*_CC_FLAGS   = $(OCPKG_BUILD_OPTIONS_GEN) $(OCPKG_ANAL_OPTIONS_GEN) -fstack-protector-strong -mstack-protector-guard=global -ftrivial-auto-var-init=pattern
  CLANGGCC:NOOPT_*_*_CC_FLAGS   = $(OCPKG_BUILD_OPTIONS_GEN) $(OCPKG_ANAL_OPTIONS_GEN) -fstack-protector-strong -mstack-protector-guard=global -ftrivial-auto-var-init=pattern
  CLANGGCC:RELEASE_*_*_CC_FLAGS = $(OCPKG_BUILD_OPTIONS_GEN) $(OCPKG_ANAL_OPTIONS_GEN) -fstack-protector-strong -mstack-protector-guard=global -ftrivial-auto-var-init=pattern
  MSFT:DEBUG_*_*_CC_FLAGS       = $(OCPKG_BUILD_OPTIONS_GEN) /wd4324 /wd4723 /GS /kernel
  MSFT:NOOPT_*_*_CC_FLAGS       = $(OCPKG_BUILD_OPTIONS_GEN) /wd4324 /wd4723 /GS /kernel
  MSFT:RELEASE_*_*_CC_FLAGS     = $(OCPKG_BUILD_OPTIONS_GEN) /wd4324 /wd4723 /GS /kernel
  XCODE:DEBUG_*_*_CC_FLAGS      = $(OCPKG_BUILD_OPTIONS_GEN) $(OCPKG_ANAL_OPTIONS_GEN) -fstack-protector-strong -ftrivial-auto-var-init=pattern
  XCODE:NOOPT_*_*_CC_FLAGS      = $(OCPKG_BUILD_OPTIONS_GEN) $(OCPKG_ANAL_OPTIONS_GEN) -fstack-protector-strong -ftrivial-auto-var-init=pattern
  XCODE:RELEASE_*_*_CC_FLAGS    = $(OCPKG_BUILD_OPTIONS_GEN) $(OCPKG_ANAL_OPTIONS_GEN) -Oz -flto -fstack-protector-strong -ftrivial-auto-var-init=pattern
