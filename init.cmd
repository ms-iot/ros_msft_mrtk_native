@echo off
setlocal enableextensions disabledelayedexpansion

: Call to initialize the isolated ROS2 build system

set "ChocolateyInstall=c:\opt\chocolatey"
set "PATH=c:\opt\chocolatey\bin;C:\opt\python37amd64\;C:\opt\python37amd64\Scripts;%PATH%"
set PATH=C:\opt\python37amd64\DLLs;%PATH%
set CMAKE_PREFIX_PATH=C:\opt\rosdeps\x64\include;%CMAKE_PREFIX_PATH%


mkdir tools\src
mkdir target\src

cd tools
vcs import src < ..\build_tools.repos

cd ..\target
vcs import src < ..\ros2_uwp.repos

xcopy /y src\ros2\orocos_kinematics_dynamics\orocos_kdl\config\FindEigen3.cmake src\ros2\eigen3_cmake_module\cmake\Modules
set CMAKE_PREFIX_PATH=C:\opt\rosdeps\x64\include\eigen3;%CMAKE_PREFIX_PATH%
