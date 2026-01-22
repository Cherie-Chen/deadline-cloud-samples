#!/bin/sh
set -xeuo pipefail

# Create the Unreal Engine directory structure
mkdir -p "$PREFIX/unreal-engine/UE_$PKG_VERSION/Engine"

# Copy the Engine files
cp -r "$SRC_DIR"/* "$PREFIX/unreal-engine/UE_$PKG_VERSION/Engine/"

# Create activation/deactivation script directories
mkdir -p "$PREFIX/etc/conda/activate.d"
mkdir -p "$PREFIX/etc/conda/deactivate.d"

# Create Windows activation script (.bat)
cat <<EOF > "$PREFIX/etc/conda/activate.d/$PKG_NAME-$PKG_VERSION-vars.bat"
set "UE_ENGINE_PATH=%CONDA_PREFIX%\unreal-engine\UE_$PKG_VERSION\Engine"
set "PATH=%CONDA_PREFIX%\unreal-engine\UE_$PKG_VERSION\Engine\Binaries\Win64;%PATH%"
EOF

# Create Unix activation script (.sh)
cat <<EOF > "$PREFIX/etc/conda/activate.d/$PKG_NAME-$PKG_VERSION-vars.sh"
export UE_ENGINE_PATH="\$CONDA_PREFIX/unreal-engine/UE_$PKG_VERSION/Engine"
export PATH="\$(cygpath '\$CONDA_PREFIX/unreal-engine/UE_$PKG_VERSION/Engine/Binaries/Win64'):\$PATH"
EOF

# Create Windows deactivation script (.bat)
cat <<EOF > "$PREFIX/etc/conda/deactivate.d/$PKG_NAME-$PKG_VERSION-vars.bat"
set "PATH=%PATH:%CONDA_PREFIX%\unreal-engine\UE_$PKG_VERSION\Engine\Binaries\Win64;=%"
set UE_ENGINE_PATH=
EOF

# Create Unix deactivation script (.sh)
cat <<EOF > "$PREFIX/etc/conda/deactivate.d/$PKG_NAME-$PKG_VERSION-vars.sh"
export PATH="\${PATH/\$(cygpath '\$CONDA_PREFIX/unreal-engine/UE_$PKG_VERSION/Engine/Binaries/Win64'):/}"
unset UE_ENGINE_PATH
EOF
