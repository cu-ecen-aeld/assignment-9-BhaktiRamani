# Overview

This repository contains assignment starter code for buildroot based assignments for the course Advanced Embedded Software Design, ECEN 5713

It also contains instructions related to modifying your buildroot project to use with supported hardware platforms.  See [this wiki page](https://github.com/cu-ecen-5013/buildroot-assignments-base/wiki/Supported-Hardware) for details.


# Buildroot Assignment Guide

## Introduction
This document outlines the steps required to configure and build a custom Buildroot image for your project. Follow the steps carefully to ensure a successful build and deployment.

## Prerequisites
Ensure you have the necessary packages installed on your build system as listed in the Buildroot documentation. Use the `which` command to verify the presence of required utilities. You may also refer to the [Assignment 4 Buildroot section](https://github.com/cu-ecen-aeld/aesd-autotest-docker/blob/master/docker/Dockerfile) for the list of packages used in the automated test runner.

## Steps to Build and Configure Buildroot

### 1. Initialize Buildroot Project Repository
After accepting the classroom assignment, your Buildroot project repository will be created with a `base_external` directory. You will update this directory to contain your custom Buildroot image configurations.

### 2. Add Buildroot as a Git Submodule
Run the following command to add Buildroot as a submodule:
```sh
 git submodule add https://gitlab.com/buildroot.org/buildroot/
```
- Checkout the branch `2024.02.x` for the Buildroot release.
- Ensure you commit the submodule addition:
```sh
git add buildroot
git commit -m "Added Buildroot submodule"
```

### 3. Configure Buildroot Package and External Directory
Modify the provided files in `buildroot-assignments-base`:
- Add the `aesd-assignments` package in `base_external/package`.
- run ./builroot_essential.sh file for adding neccessary buildroot packages.
- Configure the package to include `tester.sh`, the writer application, and `finder.sh` in `/usr/bin`.
- Ensure necessary dependencies and configuration files are included.

#### a. Create and Update Buildroot External Files
- Add `base_external/Config.in`, `external.mk`, and `external.desc`.
- Use `project_base` as the external name in `external.desc`.
- Make sure to add git url (SSH type) and working commit's commit - id
- Make sure that any Makefiles does not contain hardcoded path - can cause github action runner failure.

#### b. Modify `finder-test.sh`
- Ensure it runs with necessary files found in the `PATH`.
- Update the script to write the finder command output to `/tmp/assignment4-result.txt`.

### 4. Initial Build
Run the build script for the first time:
```sh
./build.sh
```
This generates a default `buildroot/.config` using `qemu_aarch64_virt_defconfig`.

### 5. Save Configuration
Save the configuration to your project-specific defconfig file:
```sh
./save-config.sh
```
This updates `base_external/configs/aesd_qemu_defconfig`.

### 6. Enable `aesd-assignments` Package
Run the following command from the `buildroot` directory:
```sh
make menuconfig
```
- Select the `aesd-assignments` package.
- Save the updated configuration.
- Run `./save-config.sh` again to persist changes.
- Commit the changes.

### 7. Final Build
Run the build script again:
```sh
./build.sh
```
**Note:** This may take several hours to complete.

### 8. Run QEMU Image
Use the script to launch your image:
```sh
./runqemu.sh
```

### 9. Add Cleanup Script
Create `clean.sh` in the root folder with the following content:
```sh
#!/bin/bash
make -C buildroot distclean
```
Ensure it is executable:
```sh
chmod +x clean.sh
```
- Don't run this file unless necessary - will erase Kernel Image

### 10. Enable SSH Support
- Add the `dropbear` package via `make menuconfig`.
- Save the configuration with `./save-config.sh`.

### 11. Set Default Root Password
- Set the root password to `root` in `make menuconfig` system configuration.
- Save the configuration.

### 12. Verify SSH Login
Ensure you can log in using SSH:
```sh
ssh root@localhost -p 10022
```

### 13. Transfer Assignment Result
Use `scp` to transfer `assignment4-result.txt` from QEMU:
```sh
scp -P 10022 root@localhost:/tmp/assignment4-result.txt assignments/assignment4/
```

### 14. Tag the Assignment
Once complete, tag the repository:
```sh
git tag assignment-4-complete
git push origin assignment-4-complete
```

## Helpful Bash files
- To push to the git (only in main branch) or to run actions runner : Use this bash file
```sh
./cmd.sh
```
- To Add necessary Build Packages
```sh
./buildroot_essential.sh
```

- To clone buildroot
```sh
./buildroot_install.sh
```

## Conclusion
By following these steps, you will have a fully functional Buildroot image configured with your assignment-specific modifications. Ensure all steps are completed before submission.

## Trouboleshooting from my end :
- if YAML file doesn't work, can change its format by writing with '|'
- if SSH doesn't work - can remove ssh and add ssh again on local machine
- Must install sshpass and add github repository security key
- If Buildroot fails - make sure buildroot is in correct branch




