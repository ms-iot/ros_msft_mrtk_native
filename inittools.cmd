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
call "%VSINSTALLDIR%\VC\Auxiliary\Build\vcvars64.bat"

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
 shift
if not (%1)==() goto GETOPTS

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
pushd tools
setlocal
set ROS2_ARCH=x64
if "%clean%"=="true" (
    if exist unity_build rd /s /q build
    if exist unity rd /s /q unity
)

call colcon build --event-handlers console_cohesion+ --merge-install --build-base .\unity_build --install-base .\unity --cmake-args -A %ROS2_ARCH%  -DCSHARP_PLATFORM=x64 -DDOTNET_CORE_ARCH=x64 -DCMAKE_SYSTEM_VERSION=10.0 --no-warn-unused-cli -DCMAKE_BUILD_TYPE=RelWithDebInfo -Wno-dev 

if "%ERRORLEVEL%" NEQ "0" goto :build_fail 
endlocal
popd
if "%BUILD%"=="unity" goto :eof

:build_x64
pushd tools
setlocal
set ROS2_ARCH=x64
if "%clean%"=="true" (
    if exist x64_build rd /s /q x64_build
    if exist x64 rd /s /q x64
)

call colcon build --event-handlers console_cohesion+ --merge-install --build-base .\x64_build --install-base .\x64 --cmake-args -A %ROS2_ARCH%  -DCSHARP_PLATFORM=x64 -DDOTNET_CORE_ARCH=x64 -DCMAKE_SYSTEM_NAME=WindowsStore -DCMAKE_SYSTEM_VERSION=10.0 --no-warn-unused-cli -DCMAKE_BUILD_TYPE=RelWithDebInfo -Wno-dev 

if "%ERRORLEVEL%" NEQ "0" goto :build_fail 
popd
if "%BUILD%"=="x64" goto :eof


:build_arm64
pushd tools
setlocal
set ROS2_ARCH=arm64
if "%clean%"=="true" (
    if exist arm64_build rd /s /q arm64_build
    if exist arm64 rd /s /q arm64
)

call colcon build --event-handlers console_cohesion+ --merge-install --build-base .\arm64_build --install-base .\arm64 --cmake-args -A %ROS2_ARCH%  -DCSHARP_PLATFORM=arm64 -DDOTNET_CORE_ARCH=arm64 -DCMAKE_SYSTEM_NAME=WindowsStore  -DCMAKE_SYSTEM_VERSION=10.0 --no-warn-unused-cli -DCMAKE_BUILD_TYPE=RelWithDebInfo -Wno-dev 

if "%ERRORLEVEL%" NEQ "0" goto :build_fail 
endlocal
popd
if "%BUILD%"=="arm64" goto :eof

:build_arm
pushd tools
setlocal
set ROS2_ARCH=arm
if "%clean%"=="true" (
    if exist arm_build rd /s /q arm_build
    if exist arm rd /s /q arm
)

call colcon build --event-handlers console_cohesion+ --merge-install --build-base .\arm_build --install-base .\arm --cmake-args -A %ROS2_ARCH%  -DCSHARP_PLATFORM=arm -DDOTNET_CORE_ARCH=arm -DCMAKE_SYSTEM_NAME=WindowsStore  -DCMAKE_SYSTEM_VERSION=10.0 --no-warn-unused-cli -DCMAKE_BUILD_TYPE=RelWithDebInfo -Wno-dev 

if "%ERRORLEVEL%" NEQ "0" goto :build_fail 
endlocal
popd
if "%BUILD%"=="arm" goto :eof

: build x86
:build_x86
pushd tools
setlocal
: x86 is called Win32 in cmakelandia
set ROS2_ARCH=Win32

if "%clean%"=="true" (
    if exist x86_build rd /s /q x86_build
    if exist x86 rd /s /q x86
)

call colcon build --event-handlers console_cohesion+ --merge-install --build-base .\x86_build --install-base .\x86 --cmake-args -A %ROS2_ARCH%  -DCSHARP_PLATFORM=x86 -DDOTNET_CORE_ARCH=x86 -DCMAKE_SYSTEM_NAME=WindowsStore  -DCMAKE_SYSTEM_VERSION=10.0 --no-warn-unused-cli -DCMAKE_BUILD_TYPE=RelWithDebInfo -Wno-dev 
if "%ERRORLEVEL%" NEQ "0" goto :build_fail 
endlocal
popd
if "%BUILD%"=="x86" goto :eof

goto :eof

:build_fail
endlocal
popd
goto :eof

:USAGE 
    echo "build [/x86 | /arm64 | /unity | /arm]"
    goto :eof

