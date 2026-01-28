# Building Amethyst-Offline for iOS

## Limitation
You are currently on **Windows**. Building an iOS application (`.ipa`) natively requires **macOS** with Xcode installed. It is **not possible** to generate a signed `.ipa` file directly on Windows without using a virtual machine or a cloud build service.

## Solution: GitHub Actions
This repository is configured with a GitHub Actions workflow (`.github/workflows/ios.yml`) that automatically builds the IPA for you.

### Option 1: Download Existing Builds
The `README.md` links to automatic builds. You can check the [Actions tab](https://github.com/DumDum192/Amethyst-Offline/actions/workflows/ios.yml) of the original repository to download the latest artifacts.

### Option 2: Build Your Own Version
If you have made custom changes (or just want to build it yourself):

1.  **Initialize a Git Repository**:
    ```bash
    git init
    git add .
    git commit -m "Ready to build"
    ```
2.  **Push to GitHub**:
    - Create a new repository on GitHub.
    - Push your code to it.
3.  **Trigger the Workflow**:
    - Go to the "Actions" tab in your new GitHub repository.
    - Select "iOS CI" on the left.
    - Click "Run workflow".

## Local Preparation Done
I have already performed the necessary preparation steps locally in case you find a way to build it (e.g., passing this folder to a Mac):
1.  **Cloned `Amethyst-iOS`**: The submodule code is now present in the `Amethyst-iOS` folder.
2.  **Applied Patches**: I have manually applied the `MinecraftResourceDownloadTask.patch` to `Amethyst-iOS/Natives/MinecraftResourceDownloadTask.m`. This enables the offline/local account functionality.

## Note on Submodules
If you push to GitHub, ensure the `Amethyst-iOS` folder is treated correctly. Since I cloned it manually, it has its own `.git` folder. You might want to remove `Amethyst-iOS/.git` to treat it as part of your main repo (monorepo structure) so that the GitHub Action uses your patched code instead of checking out the fresh submodule.

**To do this before pushing:**
```bash
rm -rf Amethyst-iOS/.git
```
*Note: You would also need to update `.github/workflows/ios.yml` to remove the `git submodule update` step if you do this.*
