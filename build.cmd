@echo off
setlocal enableextensions

: Call to build the isolated ROS2 build system
set ChocolateyInstall=c:\opt\chocolatey
set PATH=c:\opt\vcpkg\installed\x64-windows\bin;c:\opt\vcpkg;c:\opt\chocolatey\bin;C:\opt\python37amd64\;C:\opt\python37amd64\Scripts;C:\opt\python37amd64\DLLs;%PATH%

set "CMAKE_PREFIX_PATH=%CMAKE_PREFIX_PATH%;C:/opt/vcpkg/installed/x64-uwp"
set "VCPKG_ROOT=c:\opt\vcpkg"
set "PATH=%PATH:c:\opt\vcpkg;c:\opt\vcpkg\installed\x64-uwp\bin;=%"
set "PATH=%VCPKG_ROOT%;%VCPKG_ROOT%\installed\x64-uwp\bin;%PATH%"

call tools\install\local_setup.bat

set ROS2_ARCH=x64
cd target
//call colcon build --merge-install --packages-ignore tf2_py examples_tf2_py rmw_fastrtps_dynamic_cpp rcl_logging_log4cxx rclcpp_components ros2trace tracetools_launch tracetools_read tracetools_test tracetools_trace --cmake-args -A x64 -DCMAKE_SYSTEM_NAME=WindowsStore -DCMAKE_SYSTEM_VERSION=10.0 -DRMW_IMPLEMENTATION=rmw_fastrtps_cpp -DTHIRDPARTY=ON -DINSTALL_EXAMPLES=OFF -DBUILD_TESTING=OFF
call colcon build --merge-install --packages-ignore tf2_py examples_tf2_py rmw_fastrtps_dynamic_cpp rcl_logging_log4cxx rcl_logging_spdlog rclcpp_components ros2trace tracetools_launch tracetools_read tracetools_test tracetools_trace --cmake-args -A %ROS2_ARCH% -DCMAKE_SYSTEM_NAME=WindowsStore -DCMAKE_SYSTEM_VERSION=10.0 -DTHIRDPARTY=ON -DINSTALL_EXAMPLES=OFF -DBUILD_TESTING=OFF -DRCL_LOGGING_IMPLEMENTATION=rcl_logging_noop

// ren target\install x64

echo Success
exit /b 0

:build_arm64
: build ARM64
set "CMAKE_PREFIX_PATH=%CMAKE_PREFIX_PATH:;C:/opt/vcpkg/installed/arm64-uwp=%"
set "CMAKE_PREFIX_PATH=%CMAKE_PREFIX_PATH%;C:/opt/vcpkg/installed/arm64-uwp"
set "VCPKG_ROOT=c:\opt\vcpkg"
set "PATH=%PATH:c:\opt\vcpkg;c:\opt\vcpkg\installed\arm64-uwp\bin;=%"
set "PATH=%VCPKG_ROOT%;%VCPKG_ROOT%\installed\arm64-uwp\bin;%PATH%"
set ChocolateyInstall=c:\opt\chocolatey 

call "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\Tools\VsDevCmd.bat" -arch=arm64 -host_arch=amd64 

 cd ..\target
: colcon build --merge-install --packages-ignore tf2_py examples_tf2_py rmw_fastrtps_dynamic_cpp rcl_logging_log4cxx rclcpp_components ros2trace tracetools_launch tracetools_read tracetools_test tracetools_trace --cmake-args -DRMW_IMPLEMENTATION=rmw_fastrtps_cpp -DTHIRDPARTY=ON -DINSTALL_EXAMPLES=OFF -DBUILD_TESTING=OFF



