#!/bin/bash

# List of required packages with correct names for Ubuntu
PACKAGES=(
    "which"
    "sed"
    "make"
    "binutils"
    "build-essential"
    "diffutils"
    "gcc"
    "g++"
    "bash"
    "patch"
    "gzip"
    "bzip2"
    "perl"
    "tar"
    "cpio"
    "unzip"
    "rsync"
    "file"
    "bc"
    "findutils"
)

# Minimum versions for some packages
REQUIRED_GCC_VERSION="4.8"
REQUIRED_GPP_VERSION="4.8"
REQUIRED_MAKE_VERSION="3.81"
REQUIRED_PERL_VERSION="5.8.7"

# Function to check installed package version
check_version() {
    local package="$1"
    local required_version="$2"
    local installed_version

    #checks version of the packae, supress any error messages, gets the first line only, extracts version from the package
    installed_version=$("$package" --version 2>/dev/null | head -n 1 | grep -oE '[0-9]+\.[0-9]+(\.[0-9]+)?')

    
    if [[ -z "$installed_version" ]]; then
        return 1  # Not installed
    fi

    if dpkg --compare-versions "$installed_version" ge "$required_version"; then
        return 0  # Installed and meets version requirement
    else
        return 1  # Installed but version is too low
    fi
}

# Update package repository
echo "Updating package list..."
sudo apt update -y

# Install required packages
for package in "${PACKAGES[@]}"; do
    #List all packages, checks for particular package in quiet mode(only checks for quiet mode) -w matches for the exacet same name avoiding 
    #partial matches - if not then installs it
    if ! dpkg -l | grep -qw "$package"; then
        echo "Installing $package..."
        #y flag to say yes for continuatiation and avoid answering y/n every time
        sudo apt install -y "$package"
    else
        echo "$package is already installed."
    fi
done

# Check versions of specific packages and upgrade if necessary
if ! check_version "gcc" "$REQUIRED_GCC_VERSION"; then
    echo "Upgrading GCC to meet version requirement..."
    sudo apt install -y gcc
fi

if ! check_version "g++" "$REQUIRED_GPP_VERSION"; then
    echo "Upgrading G++ to meet version requirement..."
    sudo apt install -y g++
fi

if ! check_version "make" "$REQUIRED_MAKE_VERSION"; then
    echo "Upgrading Make to meet version requirement..."
    sudo apt install -y make
fi

if ! check_version "perl" "$REQUIRED_PERL_VERSION"; then
    echo "Upgrading Perl to meet version requirement..."
    sudo apt install -y perl
fi

# Ensure that 'file' exists in /usr/bin/file
if [[ ! -f "/usr/bin/file" ]]; then
    echo "Fixing 'file' location..."
    sudo ln -s "$(which file)" /usr/bin/file
fi

sudo apt update
sudo apt upgrade

echo "All required packages are installed and updated as needed."

