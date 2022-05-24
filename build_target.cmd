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
set CMAKE_PREFIX_PATH_ORIG=%CMAKE_PREFIX_PATH%
set PATH_ORIG=%PATH%

set PATH=c:\opt\ros\foxy\x64\tools\vcpkg;c:\opt\chocolatey\bin;C:\opt\ros\foxy\x64;C:\opt\ros\foxy\x64\Scripts;%PATH%
set VCPKG_ROOT=c:\opt\ros\foxy\x64\tools\vcpkg
set PYTHONHOME=C:\opt\ros\foxy\x64


:: Parse options
:GETOPTS
if /I "%~1" == "/?" goto USAGE
if /I "%~1" == "/Help" goto USAGE
if /I "%~1" == "/x86" (
    set BUILD_ARCH=x86
    set BUILD_BASE=x86
    set BUILD_SYSTEM=WindowsStore
    call "%VSINSTALLDIR%\VC\Auxiliary\Build\vcvars64.bat"
    set "CMAKE_PREFIX_PATH=%VCPKG_ROOT%/installed/x86-uwp;%CMAKE_PREFIX_PATH_ORIG%"
    set "PATH=%VCPKG_ROOT%;%VCPKG_ROOT%\installed\x86-uwp\bin;%PATH_ORIG%"
)

 if /I "%~1" == "/x64" (
    set BUILD_ARCH=x64
    set BUILD_BASE=x64
    set BUILD_SYSTEM=WindowsStore
    call "%VSINSTALLDIR%\VC\Auxiliary\Build\vcvars64.bat"
    set "CMAKE_PREFIX_PATH=%VCPKG_ROOT%/installed/x64-uwp;%CMAKE_PREFIX_PATH_ORIG%"
    set "PATH=%VCPKG_ROOT%;%VCPKG_ROOT%\installed\x64-uwp\bin;%PATH_ORIG%"
)
 
 if /I "%~1" == "/arm64" (
    set BUILD_ARCH=arm64
    set BUILD_BASE=arm64
    set BUILD_SYSTEM=WindowsStore
    call "%VSINSTALLDIR%\VC\Auxiliary\Build\vcvarsamd64_arm64.bat"
    set "CMAKE_PREFIX_PATH=%VCPKG_ROOT%/installed/arm64-uwp;%CMAKE_PREFIX_PATH_ORIG%"
    set "PATH=%VCPKG_ROOT%;%VCPKG_ROOT%\installed\arm64-uwp\bin;%PATH_ORIG%"
)
 
 if /I "%~1" == "/arm" (
    set BUILD_ARCH=arm
    set BUILD_BASE=arm
    set BUILD_SYSTEM=WindowsStore
    call "%VSINSTALLDIR%\VC\Auxiliary\Build\vcvarsamd64_arm.bat"
    set "CMAKE_PREFIX_PATH=%VCPKG_ROOT%/installed/arm-uwp;%CMAKE_PREFIX_PATH_ORIG%"
    set "PATH=%VCPKG_ROOT%;%VCPKG_ROOT%\installed\arm-uwp\bin;%PATH_ORIG%"
)

 if /I "%~1" == "/unity" (
    set BUILD_ARCH=x64
    set BUILD_BASE=unity
    set BUILD_SYSTEM=Windows
    call "%VSINSTALLDIR%\VC\Auxiliary\Build\vcvars64.bat"
    set "CMAKE_PREFIX_PATH=%VCPKG_ROOT%/installed/x64-windows;%CMAKE_PREFIX_PATH_ORIG%"
    set "PATH=%VCPKG_ROOT%;%VCPKG_ROOT%\installed\x64-windows\bin;%PATH_ORIG%"
)
if /I "%~1" == "/clean" set clean=true
shift

if not (%1)==() goto GETOPTS

: Call to build the isolated ROS2 build system
set ChocolateyInstall=c:\opt\chocolatey

set ARCH_LIST=x64 x86 arm arm64 unity

if "%clean%"=="true" (
    pushd target
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
call tools\%BUILD_BASE%\local_setup.bat
pushd target
call colcon build --event-handlers console_cohesion+ --merge-install --build-base .\%BUILD_BASE%_build --install-base .\%BUILD_BASE% --packages-ignore tf2_bullet tf2_py examples_tf2_py rmw_fastrtps_dynamic_cpp rcl_logging_log4cxx rcl_logging_spdlog ros2trace tracetools_launch tracetools_read tracetools_test tracetools_trace rcldotnet_examples --cmake-args -A %BUILD_ARCH%  -DCSHARP_PLATFORM=%BUILD_ARCH% -DDOTNET_CORE_ARCH=%BUILD_ARCH% -DCMAKE_SYSTEM_NAME=%BUILD_SYSTEM% -DCMAKE_SYSTEM_VERSION=10.0 -DTHIRDPARTY=ON -DINSTALL_EXAMPLES=OFF -DBUILD_TESTING=OFF -DSHM_TRANSPORT_DEFAULT=OFF -DRCL_LOGGING_IMPLEMENTATION=rcl_logging_noop --no-warn-unused-cli -DCMAKE_BUILD_TYPE=RelWithDebInfo -Wno-dev 
if "%ERRORLEVEL%" NEQ "0" goto :build_fail 
goto :build_succeeded

:build_fail
endlocal
popd
goto :eof

:USAGE 
    echo "build [/x64|/x86|/arm64|/arm] [/clean]"
    goto :eof

:build_succeeded
endlocal
popd