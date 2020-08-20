@echo off
setlocal enableextensions disabledelayedexpansion

: Call to initialize the isolated ROS2 build system

set ChocolateyInstall=c:\opt\chocolatey
set PATH=c:\opt\vcpkg\installed\x64-windows\bin;c:\opt\vcpkg;c:\opt\chocolatey\bin;C:\opt\python37amd64\;C:\opt\python37amd64\Scripts;C:\opt\python37amd64\DLLs;%PATH%

set "CMAKE_PREFIX_PATH=%CMAKE_PREFIX_PATH:;C:/opt/vcpkg/installed/x64-uwp=%"
set "CMAKE_PREFIX_PATH=%CMAKE_PREFIX_PATH%;C:/opt/vcpkg/installed/x64-uwp"
set "VCPKG_ROOT=c:\opt\vcpkg"
set "PATH=%PATH:c:\opt\vcpkg;c:\opt\vcpkg\installed\x64-uwp\bin;=%"
set "PATH=%VCPKG_ROOT%;%VCPKG_ROOT%\installed\x64-uwp\bin;%PATH%"


mkdir tools\src
mkdir target\src

cd tools
vcs import src < ..\build_tools.repos

cd ..\target
vcs import src < ..\ros2_uwp.repos

xcopy /y src\ros2\orocos_kinematics_dynamics\orocos_kdl\config\FindEigen3.cmake src\ros2\eigen3_cmake_module\cmake\Modules
set CMAKE_PREFIX_PATH=C:\opt\rosdeps\x64\include\eigen3;%CMAKE_PREFIX_PATH%


vcpkg install protobuf:x64-windows
vcpkg install protobuf:x64-uwp
vcpkg install opencv4:x64-uwp
vcpkg install apriltag:x64-uwp
vcpkg install eigen3:x64-uwp

cd tools
call colcon build --merge-install --cmake-args -DBUILD_TESTING=OFF
call install\local_setup.bat


