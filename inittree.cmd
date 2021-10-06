@echo off
setlocal enableextensions disabledelayedexpansion

if NOT EXIST "c:\opt\vcpkg\vcpkg.exe" goto :novcpkg

if "%VSINSTALLDIR%" == "" (
    if exist "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community" (
        set "VSINSTALLDIR=C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\"
    )
    if exist "C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise" (
        set "VSINSTALLDIR=C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\"
    )
)    
echo "VSInstallDir is %VSINSTALLDIR%"
call "%VSINSTALLDIR%\VC\Auxiliary\Build\vcvars64.bat"

set VisualStudioVersion=16.0

: Call to initialize the isolated ROS2 build system
mkdir c:\opt\chocolatey
set PYTHONHOME=C:\opt\python37amd64\
set ChocolateyInstall=c:\opt\chocolatey
set PATH=c:\opt\chocolatey\bin;C:\opt\python37amd64\;C:\opt\python37amd64\Scripts;C:\opt\python37amd64\DLLs;%PATH%
choco source add -n=ros-win -s="https://aka.ms/ros/public" --priority=1
choco upgrade ros-colcon-tools -y --execution-timeout=0 --pre

: choco upgrade ros_vcpkg -y --execution-timeout=0 --pre
: include staged vcpkgs

set VCPKG_ROOT=c:\opt\vcpkg

call pip install vcstool
call pip install lark-parser

mkdir tools\src
mkdir target\src

pushd tools
C:\opt\python37amd64\Scripts\vcs.exe import src < ..\build_tools.repos
popd

pushd target
C:\opt\python37amd64\Scripts\vcs.exe import src < ..\ros2_uwp.repos
xcopy /y src\ros2\orocos_kinematics_dynamics\orocos_kdl\config\FindEigen3.cmake src\ros2\eigen3_cmake_module\cmake\Modules
popd

pushd tools
call colcon build --merge-install --cmake-args -DBUILD_TESTING=OFF
popd

goto :eof

:novcpkg
echo "VCPkg not found at c:\opt\vcpkg\vcpkg.exe"
dir c:\opt

exit /1
