# Implementation Plan - Final Verification

## Goal
Ensure the `Amethyst-Offline` iOS build succeeds on GitHub Actions by verifying all dependencies are present and resolving compilation errors.

## Current State
- **Fixed**: `Amethyst-iOS` submodule populated.
- **Fixed**: `MobileGlues` dependencies (`FastSTL`, `glm`, `xxhash`) populated.
- **Fixed**: `gl4es` source populated.
- **Fixed**: `JavaLauncher.m` missing `mach/mach.h` header.
- **Pending**: Warning about missing `tokenDataOfProfile:` in `BaseAuthenticator.m`.
- **Pending**: Verification of other `external` libraries.

## Proposed Changes

### 1. Fix `BaseAuthenticator` Warning
The compiler warned: `method definition for 'tokenDataOfProfile:' not found`.
- **Action**: Check `Amethyst-iOS/Natives/authenticator/BaseAuthenticator.m`.
- **Fix**: Implement the method or remove the declaration if unused.

### 2. Verify External Dependencies
Check `Amethyst-iOS/Natives/external` for any other empty directories that should be submodules.
- **Targets**: `AltKit`, `UnzipKit`, `ballpa1n`, `lzma`, `mesa`.

### 3. Verify `gl4es` Build
Ensure `CMakeLists.txt` references the files we added correctly.

## Verification
- User will push changes.
- Successful GitHub Actions run (generating `.ipa`) is the final success metric.
