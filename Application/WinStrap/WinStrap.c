/** @file
  Load SSDT-PCI and apply BUF0 to BUF1 patch before starting Windows booter.

  Copyright (c) 2026, ilikesn0w. All rights reserved.
  SPDX-License-Identifier: BSD-3-Clause
**/

#include <Uefi.h>

#include "SSDT-PCI.h"

#include <Library/DebugLib.h>
#include <Library/DevicePathLib.h>
#include <Library/UefiApplicationEntryPoint.h>
#include <Library/UefiBootServicesTableLib.h>
#include <Library/MemoryAllocationLib.h>

#include <Library/OcAcpiLib.h>

#include <Protocol/DevicePath.h>
#include <Protocol/LoadedImage.h>

#define REAL_MS_BOOTER_PATH     L"\\EFI\\Microsoft\\Boot\\rbootmgfw.efi"
#define REAL_MS_CD_BOOTER_PATH  L"\\EFI\\Microsoft\\Boot\\rcdboot.efi"
#define REAL_BOOTSTRAP_PATH     L"\\EFI\\BOOT\\RBOOTX64.EFI"

//
// Credits to Dortania for providing this patch.
// Source: https://github.com/dortania/OpenCore-Legacy-Patcher/blob/main/payloads/Config/config.plist#L138-#L165
//
STATIC CONST UINT8  mFind[]    = { 0x42, 0x55, 0x46, 0x30 };
STATIC CONST UINT8  mReplace[] = { 0x42, 0x55, 0x46, 0x31 };

STATIC OC_ACPI_PATCH  mBuf0ToBuf1Patch = { 0 };

STATIC
EFI_STATUS
LoadBooter (
  IN EFI_HANDLE  DeviceHandle,
  IN CHAR16      *BooterPath,
  IN EFI_HANDLE  ParentImageHandle
  )
{
  EFI_STATUS                Status;
  EFI_DEVICE_PATH_PROTOCOL  *BooterDp;
  EFI_HANDLE                BooterHandle;

  BooterDp = FileDevicePath (DeviceHandle, BooterPath);
  if (BooterDp == NULL) {
    DEBUG ((DEBUG_INFO, "WS: Failed to build booter path\n"));
    return EFI_NOT_FOUND;
  }

  BooterHandle = NULL;
  Status       = gBS->LoadImage (
                        FALSE,
                        ParentImageHandle,
                        BooterDp,
                        NULL,
                        0,
                        &BooterHandle
                        );
  if (EFI_ERROR (Status)) {
    DEBUG ((DEBUG_INFO, "WS: Failed to load booter - %r\n", Status));
    FreePool (BooterDp);
    return Status;
  }

  FreePool (BooterDp);

  Status = gBS->StartImage (
                  BooterHandle,
                  NULL,
                  NULL
                  );
  if (EFI_ERROR (Status)) {
    DEBUG ((DEBUG_INFO, "WS: Failed to start booter - %r\n", Status));
    return Status;
  }

  return Status;
}

EFI_STATUS
EFIAPI
UefiMain (
  IN EFI_HANDLE        ImageHandle,
  IN EFI_SYSTEM_TABLE  *SystemTable
  )
{
  EFI_STATUS                 Status;
  OC_ACPI_CONTEXT            Context;
  EFI_LOADED_IMAGE_PROTOCOL  *LoadedImage;

  Status = AcpiInitContext (&Context);
  if (!EFI_ERROR (Status)) {
    //
    // Credits to Dortania for providing this patch.
    // Source: https://github.com/dortania/OpenCore-Legacy-Patcher/blob/main/payloads/Config/config.plist#L138-#L165
    //
    mBuf0ToBuf1Patch.Base           = "\\_SB_.PCI0";
    mBuf0ToBuf1Patch.BaseSkip       = 0;
    mBuf0ToBuf1Patch.Count          = 1;
    mBuf0ToBuf1Patch.Find           = mFind;
    mBuf0ToBuf1Patch.Limit          = 0;
    mBuf0ToBuf1Patch.Mask           = NULL;
    mBuf0ToBuf1Patch.OemTableId     = 0;
    mBuf0ToBuf1Patch.Replace        = mReplace;
    mBuf0ToBuf1Patch.Size           = sizeof (mReplace);
    mBuf0ToBuf1Patch.ReplaceMask    = NULL;
    mBuf0ToBuf1Patch.Skip           = 0;
    mBuf0ToBuf1Patch.TableLength    = 0;
    mBuf0ToBuf1Patch.TableSignature = SIGNATURE_32 ('D', 'S', 'D', 'T');

    Status = AcpiApplyPatch (&Context, &mBuf0ToBuf1Patch);
    if (!EFI_ERROR (Status)) {
      Status = AcpiInsertTable (
                 &Context,
                 mSsdtPciData,
                 mSsdtPciDataSize
                 );
      if (!EFI_ERROR (Status)) {
        Status = AcpiApplyContext (&Context);
      }
    }

    if (EFI_ERROR (Status)) {
      DEBUG ((DEBUG_ERROR, "WS: ACPI patching failed, booting Windows without patches - %r\n", Status));
    }

    AcpiFreeContext (&Context);
  } else {
    DEBUG ((DEBUG_ERROR, "WS: ACPI context init failed - %r\n", Status));
  }

  Status = gBS->HandleProtocol (
                  ImageHandle,
                  &gEfiLoadedImageProtocolGuid,
                  (VOID **)&LoadedImage
                  );
  if (EFI_ERROR (Status)) {
    DEBUG ((DEBUG_ERROR, "WS: Failed to get LoadedImage - %r\n", Status));
    return Status;
  }

  Status = LoadBooter (LoadedImage->DeviceHandle, REAL_MS_BOOTER_PATH, ImageHandle);
  if (EFI_ERROR (Status)) {
    DEBUG ((DEBUG_INFO, "WS: Failed to load real Windows booter with %r, trying real bootstrap\n", Status));
    Status = LoadBooter (LoadedImage->DeviceHandle, REAL_BOOTSTRAP_PATH, ImageHandle);
    if (EFI_ERROR (Status)) {
      DEBUG ((DEBUG_INFO, "WS: Failed to load real bootstrap with %r, trying real cdboot\n", Status));
      Status = LoadBooter (LoadedImage->DeviceHandle, REAL_MS_CD_BOOTER_PATH, ImageHandle);
      if (EFI_ERROR (Status)) {
        DEBUG ((DEBUG_ERROR, "WS: Failed to load real cdboot - %r\n", Status));
        return Status;
      }
    }
  }

  return Status;
}
