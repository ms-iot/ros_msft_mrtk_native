@echo off
setlocal enableextensions

: Call to build the isolated ROS2 build system
set ChocolateyInstall=c:\opt\chocolatey
set PATH=c:\opt\chocolatey\bin;C:\opt\python37amd64\;C:\opt\python37amd64\Scripts;C:\opt\python37amd64\DLLs;%PATH%
set VCPKG_ROOT=c:\opt\vcpkg
set PYTHONHOME=C:\opt\python37amd64\

set CMAKE_PREFIX_PATH_ORIG=%CMAKE_PREFIX_PATH%
set PATH_ORIG=%PATH%

set CMAKE_PREFIX_PATH=C:/opt/vcpkg/installed/x64-uwp;%CMAKE_PREFIX_PATH_ORIG%
set PATH=c:\opt\vcpkg;c:\opt\vcpkg\installed\x64-uwp\bin;%PATH_ORIG%

call tools\install\local_setup.bat

set ROS2_ARCH=x64
pushd target
rd /s build
call colcon build --merge-install --packages-ignore tf2_py examples_tf2_py rmw_fastrtps_dynamic_cpp rcl_logging_log4cxx rcl_logging_spdlog rclcpp_components ros2trace tracetools_launch tracetools_read tracetools_test tracetools_trace rcldotnet_examples --cmake-args -A %ROS2_ARCH% -DCMAKE_SYSTEM_NAME=WindowsStore -DCMAKE_SYSTEM_VERSION=10.0 -DTHIRDPARTY=ON -DINSTALL_EXAMPLES=OFF -DBUILD_TESTING=OFF -DRCL_LOGGING_IMPLEMENTATION=rcl_logging_noop --no-warn-unused-cli  -DCMAKE_BUILD_TYPE=RelWithDebInfo
ren install x64

:build_arm64
: build ARM64
set CMAKE_PREFIX_PATH=C:/opt/vcpkg/installed/arm64-uwp;%CMAKE_PREFIX_PATH_ORIG%
set PATH=c:\opt\vcpkg;c:\opt\vcpkg\installed\arm64-uwp\bin;%PATH_ORIG%

rd /s build
set ROS2_ARCH=arm64
call colcon build --merge-install --packages-ignore tf2_py examples_tf2_py rmw_fastrtps_dynamic_cpp rcl_logging_log4cxx rcl_logging_spdlog rclcpp_components ros2trace tracetools_launch tracetools_read tracetools_test tracetools_trace rcldotnet_examples --cmake-args -A %ROS2_ARCH% -DDOTNET_CORE_ARCH=anycpu -DCMAKE_SYSTEM_NAME=WindowsStore -DCMAKE_SYSTEM_VERSION=10.0 -DINSTALL_EXAMPLES=OFF -DBUILD_TESTING=OFF -DRCL_LOGGING_IMPLEMENTATION=rcl_logging_noop --no-warn-unused-cli  -DCMAKE_BUILD_TYPE=RelWithDebInfo
ren install arm64

: build x86
set CMAKE_PREFIX_PATH=C:/opt/vcpkg/installed/x86-uwp;%CMAKE_PREFIX_PATH_ORIG%
set PATH=c:\opt\vcpkg;c:\opt\vcpkg\installed\x86-uwp\bin;%PATH_ORIG%

rd /s build
set ROS2_ARCH=Win32
call colcon build --merge-install --packages-ignore tf2_py examples_tf2_py rmw_fastrtps_dynamic_cpp rcl_logging_log4cxx rcl_logging_spdlog rclcpp_components ros2trace tracetools_launch tracetools_read tracetools_test tracetools_trace rcldotnet_examples --cmake-args -A %ROS2_ARCH% -DDOTNET_CORE_ARCH=anycpu -DCMAKE_SYSTEM_NAME=WindowsStore -DCMAKE_SYSTEM_VERSION=10.0 -DTHIRDPARTY=ON -DINSTALL_EXAMPLES=OFF -DBUILD_TESTING=OFF -DRCL_LOGGING_IMPLEMENTATION=rcl_logging_noop --no-warn-unused-cli  -DCMAKE_BUILD_TYPE=RelWithDebInfo
ren install x86

popd
