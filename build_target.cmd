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
echo "Current dir is %~dp0"

set clean=false
set DEBUG_CMD=
set CMAKE_PREFIX_PATH_ORIG=%CMAKE_PREFIX_PATH%
set PATH_ORIG=%PATH%

set PYTHONHOME=C:\opt\mrtk_python
set ChocolateyInstall=c:\opt\mrtk_chocolatey
set PATH=c:\opt\mrtk_vcpkg;c:\opt\chocolatey\bin;C:\opt\mrtk_python;C:\opt\mrtk_python\Scripts;%PATH%
set VCPKG_ROOT=c:\opt\mrtk_vcpkg

set ROS_TOOLS_DIR=%~dp0\tools

:: Parse options
:GETOPTS
if /I "%~1" == "/?" goto USAGE
if /I "%~1" == "/Help" goto USAGE
if /I "%~1" == "/x64" (
    set BUILD_ARCH=x64
    set BUILD_BASE=x64
    set BUILD_SYSTEM=WindowsStore
    call "%VSINSTALLDIR%\VC\Auxiliary\Build\vcvars64.bat"
    set "VCPKG_INSTALLED=%VCPKG_ROOT%\installed\x64-uwp"
)
 
if /I "%~1" == "/arm64" (
    set BUILD_ARCH=arm64
    set BUILD_BASE=arm64
    set BUILD_SYSTEM=WindowsStore
    call "%VSINSTALLDIR%\VC\Auxiliary\Build\vcvarsamd64_arm64.bat"
    set "VCPKG_INSTALLED=%VCPKG_ROOT%\installed\arm64-uwp"
)
 
if /I "%~1" == "/unity" (
    set BUILD_ARCH=x64
    set BUILD_BASE=unity
    set BUILD_SYSTEM=Windows
    call "%VSINSTALLDIR%\VC\Auxiliary\Build\vcvars64.bat"
    set "VCPKG_INSTALLED=%VCPKG_ROOT%\installed\x64-windows"
)

if /I "%~1" == "/clean" set clean=true
shift

if not (%1)==() goto GETOPTS

set ARCH_LIST=x64 arm64 unity

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

: Instead of calling tools\build_arch\setup.bat, we need to break it out manually
: This is done because cmake will resolve a ROS install in opt rather than the one we built here. 
: just now.
: in this directory...
echo "CMAKE_PREFIX_PATH is %CMAKE_PREFIX_PATH%"
echo "PATH is %PATH%"

call tools\%BUILD_ARCH%\local_setup.bat

set "CMAKE_PREFIX_PATH=%VCPKG_INSTALLED%;%ROS_TOOLS_DIR%\%BUILD_ARCH%;%CMAKE_PREFIX_PATH%"
set "PATH=%VCPKG_INSTALLED%\bin;%ROS_TOOLS_DIR%\%BUILD_ARCH%\bin;%ROS_TOOLS_DIR%\%BUILD_ARCH%\Scripts;%PATH%"

pushd target
call colcon build --event-handlers console_cohesion+ --merge-install --build-base .\%BUILD_BASE%_build --install-base .\%BUILD_BASE% --packages-ignore tf2_bullet tf2_py examples_tf2_py rmw_fastrtps_dynamic_cpp rcl_logging_log4cxx rcl_logging_spdlog ros2trace tracetools_launch tracetools_read tracetools_test tracetools_trace rcldotnet_examples --cmake-args -A %BUILD_ARCH%  -DCSHARP_PLATFORM=%BUILD_ARCH% -DDOTNET_CORE_ARCH=%BUILD_ARCH% -DCMAKE_SYSTEM_NAME=%BUILD_SYSTEM% -DCMAKE_SYSTEM_VERSION=10.0 -DTHIRDPARTY=ON -DINSTALL_EXAMPLES=OFF -DBUILD_TESTING=OFF -DSHM_TRANSPORT_DEFAULT=OFF -DRCL_LOGGING_IMPLEMENTATION=rcl_logging_noop --no-warn-unused-cli -DCMAKE_BUILD_TYPE=RelWithDebInfo -Wno-dev -DCMAKE_CXX_FLAGS=" /EHsc /DOPENSSL_NO_DEPRECATED /DOPENSSL_NO_DEPRECATED_3_0"
if "%ERRORLEVEL%" NEQ "0" goto :build_fail 
goto :build_succeeded

:build_fail
    echo "build has failed"
popd
goto :eof

:USAGE 
    echo "build [/x64|/x86|/arm64|/arm] [/clean]"
    goto :eof

:build_succeeded
popd