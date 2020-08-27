@echo off
setlocal enableextensions

: Call to build the isolated ROS2 build system
set ChocolateyInstall=c:\opt\chocolatey
set PATH=c:\opt\chocolatey\bin;C:\opt\python37amd64\;C:\opt\python37amd64\Scripts;C:\opt\python37amd64\DLLs;%PATH%
set VCPKG_ROOT=c:\opt\vcpkg

set CMAKE_PREFIX_PATH_ORIG=%CMAKE_PREFIX_PATH%
set PATH_ORIG=%PATH%

set CMAKE_PREFIX_PATH=%CMAKE_PREFIX_PATH_ORIG%;C:/opt/vcpkg/installed/x64-uwp
set PATH=%PATH_ORIG%c:\opt\vcpkg;c:\opt\vcpkg\installed\x64-uwp\bin

call tools\install\local_setup.bat

set ROS2_ARCH=x64
cd target
colcon build --merge-install --packages-ignore tf2_py rmw_fastrtps_dynamic_cpp rcl_logging_log4cxx rcl_logging_spdlog rclcpp_components ros2trace tracetools_launch tracetools_read tracetools_test tracetools_trace rcldotnet_examples --cmake-args -A %ROS2_ARCH% -DCMAKE_SYSTEM_NAME=WindowsStore -DCMAKE_SYSTEM_VERSION=10.0 -DTHIRDPARTY=ON -DINSTALL_EXAMPLES=OFF -DBUILD_TESTING=OFF -DRCL_LOGGING_IMPLEMENTATION=rcl_logging_noop --no-warn-unused-cli  -DCMAKE_BUILD_TYPE=RelWithDebInfo

: ren target\install x64

echo Success
exit /b 0

:build_arm64
: build ARM64
set CMAKE_PREFIX_PATH=%CMAKE_PREFIX_PATH_ORIG%;C:/opt/vcpkg/installed/arm64-uwp
set PATH=%PATH_ORIG%c:\opt\vcpkg;c:\opt\vcpkg\installed\arm64-uwp\bin

call tools\install\local_setup.bat

set ROS2_ARCH=arm64
cd target
call colcon build --merge-install --packages-ignore tf2_py examples_tf2_py rmw_fastrtps_dynamic_cpp rcl_logging_log4cxx rcl_logging_spdlog rclcpp_components ros2trace tracetools_launch tracetools_read tracetools_test tracetools_trace rcldotnet_examples --cmake-args -A %ROS2_ARCH% -DCMAKE_SYSTEM_NAME=WindowsStore -DCMAKE_SYSTEM_VERSION=10.0 -DINSTALL_EXAMPLES=OFF -DBUILD_TESTING=OFF -DRCL_LOGGING_IMPLEMENTATION=rcl_logging_noop --no-warn-unused-cli  -DCMAKE_BUILD_TYPE=RelWithDebInfo


: build x86
set CMAKE_PREFIX_PATH=%CMAKE_PREFIX_PATH_ORIG%;C:/opt/vcpkg/installed/x86-uwp
set PATH=%PATH_ORIG%c:\opt\vcpkg;c:\opt\vcpkg\installed\x86-uwp\bin
set ROS2_ARCH=Win32
cd target
colcon build --merge-install --packages-ignore tf2_py rmw_fastrtps_dynamic_cpp rcl_logging_log4cxx rcl_logging_spdlog rclcpp_components ros2trace tracetools_launch tracetools_read tracetools_test tracetools_trace rcldotnet_examples --cmake-args -A %ROS2_ARCH% -DDOTNET_CORE_ARCH=anycpu -DCMAKE_SYSTEM_NAME=WindowsStore -DCMAKE_SYSTEM_VERSION=10.0 -DTHIRDPARTY=ON -DINSTALL_EXAMPLES=OFF -DBUILD_TESTING=OFF -DRCL_LOGGING_IMPLEMENTATION=rcl_logging_noop --no-warn-unused-cli  -DCMAKE_BUILD_TYPE=RelWithDebInfo

