@echo off
setlocal enableextensions disabledelayedexpansion

<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> c6ff0d8... Breakup nuget, fix pipeline
:: Parse options
:GETOPTS
 if /I "%~1" == "/?" goto USAGE
 if /I "%~1" == "/Help" goto USAGE
 if /I "%~1" == "/x86" set BUILD=x86
 if /I "%~1" == "/arm64" set BUILD=arm64
<<<<<<< HEAD
 if /I "%~1" == "/arm" set BUILD=arm
 if /I "%~1" == "/x64" set BUILD=x64
 if /I "%~1" == "/unity" set BUILD=unity
 shift
if not (%1)==() goto GETOPTS

=======
>>>>>>> afd4467... Add separate vcpkg build for speed
=======
 shift
if not (%1)==() goto GETOPTS

>>>>>>> c6ff0d8... Breakup nuget, fix pipeline
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

if "%BUILD%"=="x86" goto :build_x86
if "%BUILD%"=="x64" goto :build_x64
if "%BUILD%"=="arm64" goto :build_arm64
if "%BUILD%"=="arm" goto :build_arm
if "%BUILD%"=="unity" goto :build_unity

:build_x86
vcpkg install protobuf:x86-uwp
vcpkg install asio:x86-uwp
vcpkg install opencv4[core]:x86-uwp
vcpkg install apriltag[core]:x86-uwp
vcpkg install eigen3:x86-uwp
vcpkg install foonathan-memory:x86-uwp
vcpkg install poco:x86-uwp
if "%BUILD%"=="x86" goto :eof

:build_arm64
vcpkg install protobuf:arm64-uwp
vcpkg install asio:arm64-uwp
vcpkg install tinyxml2:arm64-uwp
vcpkg install opencv4[core]:arm64-uwp
vcpkg install apriltag[core]:arm64-uwp
vcpkg install eigen3:arm64-uwp
vcpkg install foonathan-memory[core]:arm64-uwp
vcpkg install poco:arm64-uwp
if "%BUILD%"=="arm64" goto :eof

:build_arm
vcpkg install protobuf:arm-uwp
vcpkg install asio:arm-uwp
vcpkg install tinyxml2:arm-uwp
vcpkg install opencv4[core]:arm-uwp
vcpkg install apriltag[core]:arm-uwp
vcpkg install eigen3:arm-uwp
vcpkg install foonathan-memory[core]:arm-uwp
vcpkg install poco:arm-uwp
if "%BUILD%"=="arm" goto :eof

:build_x64
vcpkg install protobuf:x64-uwp
vcpkg install asio:x64-uwp
vcpkg install opencv4[core]:x64-uwp
vcpkg install apriltag[core]:x64-uwp
vcpkg install eigen3:x64-uwp
vcpkg install foonathan-memory[core]:x64-uwp
vcpkg install poco:x64-uwp
if "%BUILD%"=="x64" goto :eof

:build_unity
vcpkg install protobuf:x64-windows
vcpkg install asio:x64-windows
vcpkg install opencv4[core]:x64-windows
vcpkg install apriltag[core]:x64-windows
vcpkg install eigen3:x64-windows
vcpkg install foonathan-memory[core]:x64-windows
vcpkg install poco:x64-windows
if "%BUILD%"=="unity" goto :eof
