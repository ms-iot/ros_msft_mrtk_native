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
 if /I "%~1" == "/x86" (
     set BUILD_ARCH=x86
     set BUILD_BASE=x86
     set BUILD_SYSTEM=WindowsStore
 )

 if /I "%~1" == "/x64" (
     set BUILD_ARCH=x64
     set BUILD_BASE=x64
     set BUILD_SYSTEM=WindowsStore
 )
 
 if /I "%~1" == "/arm64" (
     set BUILD_ARCH=arm64
     set BUILD_BASE=arm64
     set BUILD_SYSTEM=WindowsStore
 )
 
 if /I "%~1" == "/arm" (
     set BUILD_ARCH=arm
     set BUILD_BASE=arm
     set BUILD_SYSTEM=WindowsStore
 )

 if /I "%~1" == "/unity" (
     set BUILD_ARCH=x64
     set BUILD_BASE=unity
     set BUILD_SYSTEM=Windows
 )
if /I "%~1" == "/clean" set clean=true
shift

if not (%1)==() goto GETOPTS

: Call to build the isolated ROS2 build system
set ChocolateyInstall=c:\opt\chocolatey

set PATH_ORIG=%PATH%

set CMAKE_PREFIX_PATH_ORIG=%CMAKE_PREFIX_PATH%
set PATH=c:\opt\ros\foxy\x64\tools\vcpkg;c:\opt\chocolatey\bin;C:\opt\ros\foxy\x64;C:\opt\ros\foxy\x64\Scripts;%PATH%
set VCPKG_ROOT=c:\opt\ros\foxy\x64\tools\vcpkg
set PYTHONHOME=C:\opt\ros\foxy\x64

set ARCH_LIST=x64 x86 arm arm64 unity

if "%clean%"=="true" (
    pushd tools
    for %%a in (%ARCH_LIST%) do ( 
        if exist %%a_build rd /s /q %%a_build
        if exist %%a rd /s /q %%a
    )
    popd

    if "%BUILD_ARCH%" == "" ( 
        goto :eof
    )
)

setlocal
call colcon build --event-handlers console_cohesion+ --merge-install --build-base .\%BUILD_BASE%_build --install-base .\%BUILD_BASE% --cmake-args -A %BUILD_ARCH%  -DCSHARP_PLATFORM=%BUILD_ARCH% -DCMAKE_SYSTEM_NAME=%BUILD_SYSTEM% -DDOTNET_CORE_ARCH=%BUILD_ARCH% -DCMAKE_SYSTEM_VERSION=10.0 --no-warn-unused-cli -DCMAKE_BUILD_TYPE=RelWithDebInfo -Wno-dev 
endlocal
if "%ERRORLEVEL%" NEQ "0" goto :build_fail 
goto :eof

:build_fail
goto :eof

:USAGE 
    echo "build [/x86 | /arm64 | /unity | /arm] [/clean]"
    goto :eof

