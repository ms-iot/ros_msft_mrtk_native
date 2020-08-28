@echo off
setlocal enableextensions disabledelayedexpansion



: Call to initialize the isolated ROS2 build system
mkdir c:\opt\chocolatey
set PYTHONHOME=C:\opt\python37amd64\
set ChocolateyInstall=c:\opt\chocolatey
choco source add -n=ros-win -s="https://aka.ms/ros/public" --priority=1
choco upgrade ros-colcon-tools -y --execution-timeout=0 --pre

: choco upgrade ros_vcpkg -y --execution-timeout=0 --pre
: include staged vcpkgs

set PATH_ORIG=%PATH%
set PATH=c:\opt\vcpkg;c:\opt\chocolatey\bin;C:\opt\python37amd64\;C:\opt\python37amd64\Scripts;C:\opt\python37amd64\DLLs;%PATH%
set VCPKG_ROOT=c:\opt\vcpkg

mkdir c:\opt
cd c:\opt
git clone https://github.com/ooeygui/vcpkg
call bootstrap-vcpkg.bat

call pip install vcs



mkdir tools\src
mkdir target\src

cd tools
vcs import src < ..\build_tools.repos

cd ..\target
vcs import src < ..\ros2_uwp.repos
cd ..

xcopy /y src\ros2\orocos_kinematics_dynamics\orocos_kdl\config\FindEigen3.cmake src\ros2\eigen3_cmake_module\cmake\Modules

: Build tooling
vcpkg install protobuf:x86-windows
vcpkg install foonathan-memory:x86-windows

vcpkg install protobuf:x64-uwp
vcpkg install asio:x64-uwp
vcpkg install opencv4[core]:x64-uwp
vcpkg install apriltag:x64-uwp
vcpkg install eigen3:x64-uwp
vcpkg install foonathan-memory[core]:x64-uwp
vcpkg install poco:x64-uwp

vcpkg install protobuf:x86-uwp
vcpkg install asio:x86-uwp
vcpkg install opencv4[core]:x86-uwp
vcpkg install apriltag:x86-uwp
vcpkg install eigen3:x86-uwp
vcpkg install foonathan-memory:x86-uwp
vcpkg install poco:x86-uwp

vcpkg install protobuf:arm64-uwp
vcpkg install asio:arm64-uwp
vcpkg install tinyxml2:arm64-uwp
vcpkg install opencv4[core]:arm64-uwp
vcpkg install apriltag:arm64-uwp
vcpkg install eigen3:arm64-uwp
vcpkg install foonathan-memory[core]:arm64-uwp
vcpkg install poco:arm64-uwp

cd tools
call colcon build --merge-install --cmake-args -DBUILD_TESTING=OFF
cd ..

