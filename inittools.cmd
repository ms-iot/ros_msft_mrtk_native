: @echo off
setlocal enableextensions disabledelayedexpansion

if "%VSINSTALLDIR%" == "" (
    if exist "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community" (
        set "VSINSTALLDIR=C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\"
    )
    if exist "C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise" (
        set "VSINSTALLDIR=C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\"
    )
)    
echo "VSInstallDir is %VSINSTALLDIR%"

set clean=false
set DEBUG_CMD=

:: Parse options
:GETOPTS
 if /I "%~1" == "/?" goto USAGE
 if /I "%~1" == "/Help" goto USAGE
 if /I "%~1" == "/x86" set BUILD=x86
 if /I "%~1" == "/x64" set BUILD=x64
 if /I "%~1" == "/arm64" set BUILD=arm64
 if /I "%~1" == "/arm" set BUILD=arm
 if /I "%~1" == "/unity" set BUILD=unity
 if /I "%~1" == "/clean" set clean=true
 if /I "%~1" == "/debug" set DEBUG_CMD=-DCMAKE_BUILD_TYPE=RelWithDebInfo
 shift
if not (%1)==() goto GETOPTS

pushd tools

: Call to build the isolated ROS2 build system
set ChocolateyInstall=c:\opt\chocolatey

set CMAKE_PREFIX_PATH_ORIG=%CMAKE_PREFIX_PATH%
set PATH=c:\opt\chocolatey\bin;C:\opt\python37amd64\;C:\opt\python37amd64\Scripts;C:\opt\python37amd64\DLLs;%PATH%
set PATH_ORIG=%PATH%
set VCPKG_ROOT=c:\opt\vcpkg
set PYTHONHOME=C:\opt\python37amd64\

if "%BUILD%"=="x86" goto :build_x86
if "%BUILD%"=="x64" goto :build_x64
if "%BUILD%"=="unity" goto :build_unity
if "%BUILD%"=="arm" goto :build_arm
if "%BUILD%"=="arm64" goto :build_arm64

:build_unity
set ROS2_ARCH=x64
if "%clean%"=="true" rd /s /q build
if exist unity (ren unity install)
if exist unity_build (ren unity_build build)
call colcon build --event-handlers console_cohesion+ --merge-install --cmake-args -A %ROS2_ARCH%  -DCSHARP_PLATFORM=x64 -DDOTNET_CORE_ARCH=x64 -DCMAKE_SYSTEM_VERSION=10.0 --no-warn-unused-cli %DEBUG_CMD% -Wno-dev 
if "%ERRORLEVEL%" NEQ "0" goto :build_fail 
if exist unity (rd /y /s unity)
if exist unity_build (rd /y /s unity_build)
ren install unity
ren install unity_build
popd
if "%BUILD%"=="unity" goto :eof

:build_x64
set ROS2_ARCH=x64
if "%clean%"=="true" rd /s /q build
if exist x64 (ren x64 install)
if exist x64_build (ren x64_build build)
call colcon build --event-handlers console_cohesion+ --merge-install --cmake-args -A %ROS2_ARCH%  -DCSHARP_PLATFORM=x64 -DDOTNET_CORE_ARCH=x64 -DCMAKE_SYSTEM_VERSION=10.0 --no-warn-unused-cli %DEBUG_CMD% -Wno-dev 
if "%ERRORLEVEL%" NEQ "0" goto :build_fail 
if exist x64 (rd /y /s x64)
if exist x64_build (rd /y /s x64_build)
ren install x64
ren install x64_build
popd
if "%BUILD%"=="x64" goto :eof


:build_arm64
set ROS2_ARCH=arm64
if "%clean%"=="true" rd /s /q build
if exist arm64 (ren arm64 install)
if exist arm64_build (ren arm64_build build)
call colcon build --event-handlers console_cohesion+ --merge-install --cmake-args -A %ROS2_ARCH%  -DCSHARP_PLATFORM=arm64 -DDOTNET_CORE_ARCH=arm64 -DCMAKE_SYSTEM_VERSION=10.0 --no-warn-unused-cli %DEBUG_CMD% -Wno-dev 
if "%ERRORLEVEL%" NEQ "0" goto :build_fail 
if exist arm64 (rd /y /s arm64)
if exist arm64_build (rd /y /s arm64_build)
ren install arm64
ren build arm64_build
popd
if "%BUILD%"=="build_arm64" goto :eof

:build_arm
set ROS2_ARCH=arm
if "%clean%"=="true" rd /s /q build
if exist arm (ren arm install)
if exist arm_build (ren arm_build build)
call colcon build --event-handlers console_cohesion+ --merge-install --cmake-args -A %ROS2_ARCH%  -DCSHARP_PLATFORM=arm -DDOTNET_CORE_ARCH=arm -DCMAKE_SYSTEM_VERSION=10.0 --no-warn-unused-cli %DEBUG_CMD% -Wno-dev 
if "%ERRORLEVEL%" NEQ "0" goto :build_fail 
if exist arm (rd /y /s arm)
if exist arm_build (rd /y /s arm_build)
ren install arm
ren build arm_build
popd
if "%BUILD%"=="build_arm64" goto :eof

popd

goto :eof

:build_fail
popd
goto :eof

:USAGE 
    echo "build [x86|arm64]"
    goto :eof

