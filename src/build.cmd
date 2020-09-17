@echo off
setlocal enableextensions

set CMAKE_PREFIX_PATH_ORIG=%CMAKE_PREFIX_PATH%
set PATH=c:\opt\chocolatey\bin;C:\opt\python37amd64\;C:\opt\python37amd64\Scripts;C:\opt\python37amd64\DLLs;%PATH%
set PATH_ORIG=%PATH%

set VCPKG_ROOT=c:\opt\vcpkg
set PYTHONHOME=C:\opt\python37amd64\

mkdir build
pushd build

mkdir arm64
pushd arm64

set CMAKE_PREFIX_PATH=C:/opt/vcpkg/installed/arm64-uwp;%CMAKE_PREFIX_PATH_ORIG%
set PATH=c:\opt\vcpkg;c:\opt\vcpkg\installed\arm64-uwp\bin;%PATH_ORIG%
call "C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build\vcvarsamd64_arm64.bat"

cmake ..\.. -A arm64 -DCMAKE_SYSTEM_NAME=WindowsStore -DCMAKE_SYSTEM_VERSION=10.0 

msbuild ros-msft-mrtk-native.sln /property:Configuration=Release /p:Platform="arm64"
popd


mkdir x64
pushd x64
set CMAKE_PREFIX_PATH=C:/opt/vcpkg/installed/x64-uwp;%CMAKE_PREFIX_PATH_ORIG%
set PATH=c:\opt\vcpkg;c:\opt\vcpkg\installed\x64-uwp\bin;%PATH_ORIG%
call "C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build\vcvars64.bat"


cmake ..\.. -A x64 -DCMAKE_SYSTEM_NAME=WindowsStore -DCMAKE_SYSTEM_VERSION=10.0 

msbuild ros-msft-mrtk-native.sln /property:Configuration=Release /p:Platform="x64"
popd


mkdir Win32
pushd Win32
set CMAKE_PREFIX_PATH=C:/opt/vcpkg/installed/x86-uwp;%CMAKE_PREFIX_PATH_ORIG%
set PATH=c:\opt\vcpkg;c:\opt\vcpkg\installed\x86-uwp\bin;%PATH_ORIG%

call "C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build\vcvarsamd64_x86.bat"

cmake ..\.. -A Win32 -DCMAKE_SYSTEM_NAME=WindowsStore -DCMAKE_SYSTEM_VERSION=10.0 

msbuild ros-msft-mrtk-native.sln /property:Configuration=Release  /p:Platform="Win32"
popd

popd
