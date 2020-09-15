: @echo off
setlocal enableextensions disabledelayedexpansion

:: Parse options
:GETOPTS
 if /I "%~1" == "/?" goto USAGE
 if /I "%~1" == "/Help" goto USAGE
 if /I "%~1" == "/x86" set BUILD=x86
 if /I "%~1" == "/arm64" set BUILD=arm64
 shift
if not (%1)==() goto GETOPTS


: Call to build the isolated ROS2 build system
set ChocolateyInstall=c:\opt\chocolatey

set CMAKE_PREFIX_PATH_ORIG=%CMAKE_PREFIX_PATH%
set PATH=c:\opt\chocolatey\bin;C:\opt\python37amd64\;C:\opt\python37amd64\Scripts;C:\opt\python37amd64\DLLs;%PATH%
set PATH_ORIG=%PATH%

set VCPKG_ROOT=c:\opt\vcpkg
set PYTHONHOME=C:\opt\python37amd64\

call tools\install\local_setup.bat

if "%BUILD%"=="x86" goto :build_x86
if "%BUILD%"=="arm64" goto :build_arm64

set CMAKE_PREFIX_PATH=C:/opt/vcpkg/installed/x64-uwp;%CMAKE_PREFIX_PATH_ORIG%
set PATH=c:\opt\vcpkg;c:\opt\vcpkg\installed\x64-uwp\bin;%PATH_ORIG%

:build_x64
set ROS2_ARCH=x64

pushd target
rd /s /q build
call colcon build --merge-install --packages-ignore tf2_py examples_tf2_py rmw_fastrtps_dynamic_cpp rcl_logging_log4cxx rcl_logging_spdlog rclcpp_components ros2trace tracetools_launch tracetools_read tracetools_test tracetools_trace rcldotnet_examples --cmake-args -A %ROS2_ARCH%  -DDOTNET_CORE_ARCH=x64 -DCMAKE_SYSTEM_NAME=WindowsStore -DCMAKE_SYSTEM_VERSION=10.0 -DTHIRDPARTY=ON -DINSTALL_EXAMPLES=OFF -DBUILD_TESTING=OFF -DRCL_LOGGING_IMPLEMENTATION=rcl_logging_noop --no-warn-unused-cli  -DCMAKE_BUILD_TYPE=RelWithDebInfo -Wno-dev
ren install x64
popd

:build_arm64
set ROS2_ARCH=arm64

set CMAKE_PREFIX_PATH=C:/opt/vcpkg/installed/arm64-uwp;%CMAKE_PREFIX_PATH_ORIG%
set PATH=c:\opt\vcpkg;c:\opt\vcpkg\installed\arm64-uwp\bin;%PATH_ORIG%

pushd target
rd /s /q build
call colcon build --merge-install --packages-ignore tf2_py examples_tf2_py rmw_fastrtps_dynamic_cpp rcl_logging_log4cxx rcl_logging_spdlog rclcpp_components ros2trace tracetools_launch tracetools_read tracetools_test tracetools_trace rcldotnet_examples --cmake-args -A %ROS2_ARCH%  -DDOTNET_CORE_ARCH=arm64 -DCMAKE_SYSTEM_NAME=WindowsStore -DCMAKE_SYSTEM_VERSION=10.0 -DINSTALL_EXAMPLES=OFF -DBUILD_TESTING=OFF -DRCL_LOGGING_IMPLEMENTATION=rcl_logging_noop --no-warn-unused-cli  -DCMAKE_BUILD_TYPE=RelWithDebInfo -Wno-dev
ren install arm64
popd
if "%BUILD%"=="arm64" goto :eof

: build x86
:build_x86
: x86 is called Win32 in cmakelandia
set ROS2_ARCH=Win32

set CMAKE_PREFIX_PATH=C:/opt/vcpkg/installed/x86-uwp;%CMAKE_PREFIX_PATH_ORIG%
set PATH=c:\opt\vcpkg;c:\opt\vcpkg\installed\x86-uwp\bin;%PATH_ORIG%

pushd target
rd /s /q build
call colcon build --merge-install --packages-ignore tf2_py examples_tf2_py rmw_fastrtps_dynamic_cpp rcl_logging_log4cxx rcl_logging_spdlog rclcpp_components ros2trace tracetools_launch tracetools_read tracetools_test tracetools_trace rcldotnet_examples --cmake-args -A %ROS2_ARCH% -DDOTNET_CORE_ARCH=x86 -DCMAKE_SYSTEM_NAME=WindowsStore -DCMAKE_SYSTEM_VERSION=10.0 -DTHIRDPARTY=ON -DINSTALL_EXAMPLES=OFF -DBUILD_TESTING=OFF -DRCL_LOGGING_IMPLEMENTATION=rcl_logging_noop --no-warn-unused-cli  -DCMAKE_BUILD_TYPE=RelWithDebInfo -Wno-dev
ren install x86
popd
if "%BUILD%"=="x86" goto :eof

goto :eof

:USAGE
    echo build [x86|arm64]
    goto :eof
