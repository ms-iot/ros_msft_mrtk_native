@echo off
setlocal enableextensions disabledelayedexpansion

: Call to build the isolated ROS2 build system

set "CMAKE_PREFIX_PATH=%CMAKE_PREFIX_PATH:;C:/opt/vcpkg/installed/x64-windows=%"
set "CMAKE_PREFIX_PATH=%CMAKE_PREFIX_PATH%;C:/opt/vcpkg/installed/x64-windows"
set "VCPKG_ROOT=c:\opt\vcpkg"
set "PATH=%PATH:c:\opt\vcpkg;c:\opt\vcpkg\installed\x64-windows\bin;=%"
set "PATH=%VCPKG_ROOT%;%VCPKG_ROOT%\installed\x64-windows\bin;%PATH%"


cd tools
colcon build --merge-install --cmake-args -DBUILD_TESTING=OFF
install\local_setup.bat

cd ..\target
colcon build --merge-install --packages-ignore tf2_py examples_tf2_py rmw_fastrtps_dynamic_cpp rcl_logging_log4cxx rclcpp_components ros2trace tracetools_launch tracetools_read tracetools_test tracetools_trace --cmake-args -DRMW_IMPLEMENTATION=rmw_fastrtps_cpp -DTHIRDPARTY=ON -DINSTALL_EXAMPLES=OFF -DBUILD_TESTING=OFF


