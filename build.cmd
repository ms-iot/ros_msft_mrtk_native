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
: Call to build the isolated ROS2 build system
set ChocolateyInstall=c:\opt\chocolatey

set CMAKE_PREFIX_PATH_ORIG=%CMAKE_PREFIX_PATH%
set PATH=c:\opt\chocolatey\bin;C:\opt\python37amd64\;C:\opt\python37amd64\Scripts;C:\opt\python37amd64\DLLs;%PATH%
set PATH_ORIG=%PATH%

set VCPKG_ROOT=c:\opt\vcpkg
set PYTHONHOME=C:\opt\python37amd64\


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

if "%BUILD%"=="x86" goto :build_x86
if "%BUILD%"=="x64" goto :build_x64
if "%BUILD%"=="unity" goto :build_unity
if "%BUILD%"=="arm" goto :build_arm
if "%BUILD%"=="arm64" goto :build_arm64

:build_unity
setlocal
set ROS2_ARCH=x64
call tools\unity\local_setup.bat

pushd target
set CMAKE_PREFIX_PATH=C:/opt/vcpkg/installed/x64-windows;%CMAKE_PREFIX_PATH_ORIG%
set PATH=c:\opt\vcpkg;c:\opt\vcpkg\installed\x64-windows\bin;%PATH_ORIG%
call "%VSINSTALLDIR%\VC\Auxiliary\Build\vcvars64.bat"

if "%clean%"=="true" (
    if exist unity_build rd /s /q unity_build
    if exist unity rd /s /q unity
)

call colcon build --event-handlers console_cohesion+ --merge-install --build-base .\unity_build --install-base .\unity --packages-ignore tf2_py examples_tf2_py rmw_fastrtps_dynamic_cpp rcl_logging_log4cxx rcl_logging_spdlog rclcpp_components ros2trace tracetools_launch tracetools_read tracetools_test tracetools_trace rcldotnet_examples --cmake-args -A %ROS2_ARCH%  -DCSHARP_PLATFORM=x64 -DDOTNET_CORE_ARCH=x64 -DCMAKE_SYSTEM_VERSION=10.0 -DTHIRDPARTY=ON -DINSTALL_EXAMPLES=OFF -DBUILD_TESTING=OFF -DRCL_LOGGING_IMPLEMENTATION=rcl_logging_noop --no-warn-unused-cli %DEBUG_CMD% -Wno-dev 
if "%ERRORLEVEL%" NEQ "0" goto :eof 
endlocal
popd
if "%BUILD%"=="unity" goto :eof

:build_x64
setlocal
set ROS2_ARCH=x64
call tools\x64\local_setup.bat

pushd target
set CMAKE_PREFIX_PATH=C:/opt/vcpkg/installed/x64-uwp;%CMAKE_PREFIX_PATH_ORIG%
set PATH=c:\opt\vcpkg;c:\opt\vcpkg\installed\x64-uwp\bin;%PATH_ORIG%
call "%VSINSTALLDIR%\VC\Auxiliary\Build\vcvars64.bat"

if "%clean%"=="true" (
    if exist x64_build rd /s /q x64_build
    if exist x64 rd /s /q x64
)

call colcon build --event-handlers console_cohesion+ --merge-install --build-base .\x64_build --install-base .\x64 --packages-ignore tf2_bullet tf2_py examples_tf2_py rmw_fastrtps_dynamic_cpp rcl_logging_log4cxx rcl_logging_spdlog ros2trace tracetools_launch tracetools_read tracetools_test tracetools_trace rcldotnet_examples --cmake-args -A %ROS2_ARCH%  -DCSHARP_PLATFORM=x64 -DDOTNET_CORE_ARCH=x64 -DCMAKE_SYSTEM_NAME=WindowsStore -DCMAKE_SYSTEM_VERSION=10.0 -DTHIRDPARTY=ON -DINSTALL_EXAMPLES=OFF -DBUILD_TESTING=OFF -DRCL_LOGGING_IMPLEMENTATION=rcl_logging_noop --no-warn-unused-cli %DEBUG_CMD% -Wno-dev 
if "%ERRORLEVEL%" NEQ "0" goto :build_fail 
endlocal
popd
if "%BUILD%"=="x64" goto :eof

:build_arm64
setlocal
set ROS2_ARCH=arm64
call tools\arm64\local_setup.bat

pushd target
set CMAKE_PREFIX_PATH=C:/opt/vcpkg/installed/arm64-uwp;%CMAKE_PREFIX_PATH_ORIG%
set PATH=c:\opt\vcpkg;c:\opt\vcpkg\installed\arm64-uwp\bin;%PATH_ORIG%
call "%VSINSTALLDIR%\VC\Auxiliary\Build\vcvarsamd64_arm64.bat"

if "%clean%"=="true" (
    if exist arm64_build rd /s /q arm64_build
    if exist install rd /s /q install
)

call colcon build --event-handlers console_cohesion+ --merge-install --build-base .\arm64_build --install-base .\arm64 --packages-ignore tf2_bullet tf2_py examples_tf2_py rmw_fastrtps_dynamic_cpp rcl_logging_log4cxx rcl_logging_spdlog ros2trace tracetools_launch tracetools_read tracetools_test tracetools_trace rcldotnet_examples --cmake-args -A %ROS2_ARCH%  -DCSHARP_PLATFORM=arm64 -DDOTNET_CORE_ARCH=arm64 -DCMAKE_SYSTEM_NAME=WindowsStore -DCMAKE_SYSTEM_VERSION=10.0 -DINSTALL_EXAMPLES=OFF -DBUILD_TESTING=OFF -DRCL_LOGGING_IMPLEMENTATION=rcl_logging_noop --no-warn-unused-cli %DEBUG_CMD% -Wno-dev
if "%ERRORLEVEL%" NEQ "0" goto :build_fail 
endlocal
popd
if "%BUILD%"=="arm64" goto :eof



:build_arm
setlocal
set ROS2_ARCH=arm
call tools\arm\local_setup.bat

pushd target
set CMAKE_PREFIX_PATH=C:/opt/vcpkg/installed/arm-uwp;%CMAKE_PREFIX_PATH_ORIG%
set PATH=c:\opt\vcpkg;c:\opt\vcpkg\installed\arm-uwp\bin;%PATH_ORIG%
call "%VSINSTALLDIR%\VC\Auxiliary\Build\vcvarsamd64_arm.bat"

if "%clean%"=="true" (
    if exist arm64_build rd /s /q arm64_build
    if exist install rd /s /q install
)

call colcon build --event-handlers console_cohesion+ --merge-install --build-base .\arm_build --install-base .\arm --packages-ignore tf2_bullet tf2_py examples_tf2_py rmw_fastrtps_dynamic_cpp rcl_logging_log4cxx rcl_logging_spdlog ros2trace tracetools_launch tracetools_read tracetools_test tracetools_trace rcldotnet_examples --cmake-args -A %ROS2_ARCH%  -DCSHARP_PLATFORM=arm -DDOTNET_CORE_ARCH=arm -DCMAKE_SYSTEM_NAME=WindowsStore -DCMAKE_SYSTEM_VERSION=10.0 -DINSTALL_EXAMPLES=OFF -DBUILD_TESTING=OFF -DRCL_LOGGING_IMPLEMENTATION=rcl_logging_noop --no-warn-unused-cli %DEBUG_CMD% -Wno-dev
if "%ERRORLEVEL%" NEQ "0" goto :build_fail 
endlocal
popd
if "%BUILD%"=="arm" goto :eof

: build x86
:build_x86
setlocal
: x86 is called Win32 in cmakelandia
set ROS2_ARCH=Win32
call tools\x86\local_setup.bat

pushd target
set CMAKE_PREFIX_PATH=C:/opt/vcpkg/installed/x86-uwp;%CMAKE_PREFIX_PATH_ORIG%
set PATH=c:\opt\vcpkg;c:\opt\vcpkg\installed\x86-uwp\bin;%PATH_ORIG%
call "%VSINSTALLDIR%\VC\Auxiliary\Build\vcvarsamd64_x86.bat"

if "%clean%"=="true" (
    if exist x86_build rd /s /q x86_build
    if exist x86 rd /s /q x86
)

call colcon build --event-handlers console_cohesion+ --merge-install --build-base .\x86_build --install-base .\x86 --packages-ignore tf2_py examples_tf2_py rmw_fastrtps_dynamic_cpp rcl_logging_log4cxx rcl_logging_spdlog ros2trace tracetools_launch tracetools_read tracetools_test tracetools_trace rcldotnet_examples --cmake-args -A %ROS2_ARCH% -DCSHARP_PLATFORM=x86 -DDOTNET_CORE_ARCH=x86 -DCMAKE_SYSTEM_NAME=WindowsStore -DCMAKE_SYSTEM_VERSION=10.0 -DTHIRDPARTY=ON -DINSTALL_EXAMPLES=OFF -DBUILD_TESTING=OFF -DRCL_LOGGING_IMPLEMENTATION=rcl_logging_noop --no-warn-unused-cli %DEBUG_CMD% -Wno-dev
if "%ERRORLEVEL%" NEQ "0" goto :build_fail 
endlocal
popd
if "%BUILD%"=="x86" goto :eof

goto :eof

:build_fail
popd
goto :eof

:USAGE 
    echo "build [/x64|/x86|/arm64|/arm] [/clean]"
    goto :eof
