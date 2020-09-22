@echo off
setlocal enableextensions disabledelayedexpansion

echo "VSInstallDir is %VSINSTALLDIR%"

if "%VSINSTALLDIR%" == "" set VSINSTALLDIR=C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise

call "%VSINSTALLDIR%\VC\Auxiliary\Build\vcvars64.bat"

if NOT EXIST "c:\opt\vcpkg\vcpkg.exe" goto :novcpkg


: Call to initialize the isolated ROS2 build system
mkdir c:\opt\chocolatey
set PYTHONHOME=C:\opt\python37amd64\
set ChocolateyInstall=c:\opt\chocolatey
choco source add -n=ros-win -s="https://aka.ms/ros/public" --priority=1
choco upgrade ros-colcon-tools -y --execution-timeout=0 --pre

: choco upgrade ros_vcpkg -y --execution-timeout=0 --pre
: include staged vcpkgs

set VCPKG_ROOT=c:\opt\vcpkg

call pip install vcs
call pip install lark-parser

mkdir tools\src
mkdir target\src

cd tools
vcs import src < ..\build_tools.repos

cd ..\target
vcs import src < ..\ros2_uwp.repos
xcopy /y src\ros2\orocos_kinematics_dynamics\orocos_kdl\config\FindEigen3.cmake src\ros2\eigen3_cmake_module\cmake\Modules
cd ..


cd tools
call colcon build --merge-install --cmake-args -DBUILD_TESTING=OFF
cd ..

exit /1
