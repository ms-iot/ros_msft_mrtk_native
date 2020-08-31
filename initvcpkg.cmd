@echo off
setlocal enableextensions disabledelayedexpansion

set PATH_ORIG=%PATH%
set PATH=c:\opt\vcpkg;c:\opt\chocolatey\bin;C:\opt\python37amd64\;C:\opt\python37amd64\Scripts;C:\opt\python37amd64\DLLs;%PATH%
set VCPKG_ROOT=c:\opt\vcpkg

mkdir c:\opt
pushd c:\opt
git clone https://github.com/ooeygui/vcpkg
call bootstrap-vcpkg.bat
popd


: Build tooling
vcpkg install protobuf:x86-windows
vcpkg install foonathan-memory:x86-windows

:build_arm64
vcpkg install protobuf:arm64-uwp
vcpkg install asio:arm64-uwp
vcpkg install tinyxml2:arm64-uwp
vcpkg install opencv4[core]:arm64-uwp
vcpkg install apriltag:arm64-uwp
vcpkg install eigen3:arm64-uwp
vcpkg install foonathan-memory[core]:arm64-uwp
vcpkg install poco:arm64-uwp

:build_x64
vcpkg install protobuf:x64-uwp
vcpkg install asio:x64-uwp
vcpkg install opencv4[core]:x64-uwp
vcpkg install apriltag:x64-uwp
vcpkg install eigen3:x64-uwp
vcpkg install foonathan-memory[core]:x64-uwp
vcpkg install poco:x64-uwp

:build_x86
vcpkg install protobuf:x86-uwp
vcpkg install asio:x86-uwp
vcpkg install opencv4[core]:x86-uwp
vcpkg install apriltag:x86-uwp
vcpkg install eigen3:x86-uwp
vcpkg install foonathan-memory:x86-uwp
vcpkg install poco:x86-uwp
