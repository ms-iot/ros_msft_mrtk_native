: @echo off
setlocal enableextensions disabledelayedexpansion

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
mkdir c:\opt\mrtk_chocolatey
set PYTHONHOME=C:\opt\mrtk_python
set ChocolateyInstall=c:\opt\mrtk_chocolatey
set PATH=c:\opt\mrtk_vcpkg;c:\opt\chocolatey\bin;C:\opt\mrtk_python;C:\opt\mrtk_python\Scripts;%PATH%
set VCPKG_ROOT=c:\opt\mrtk_vcpkg

choco install python3 --params "/InstallDir:C:\opt\mrtk_python" --version=3.8.5 -y
: choco source add -n=ros-win -s="https://aka.ms/ros/public" --priority=1 -y


call pip install vcstool
call pip install lark-parser
call pip install colcon-common-extensions

if exist "%VCPKG_ROOT%" goto :build_tools
mkdir c:\opt\
pushd c:\opt\
git clone https://github.com/ooeygui/vcpkg c:\opt\mrtk_vcpkg
cd c:\opt\mrtk_vcpkg
call bootstrap-vcpkg.bat
popd

:build_tools
vcpkg install openssl:arm64-uwp
vcpkg install foonathan-memory:x64-windows
vcpkg install foonathan-memory[core]:arm64-uwp
vcpkg install foonathan-memory[core]:x64-uwp

vcpkg install eigen3:x64-windows
vcpkg install eigen3:arm64-uwp
vcpkg install eigen3:x64-uwp

vcpkg install openssl:x64-windows
vcpkg install openssl:arm64-uwp
vcpkg install openssl:x64-uwp

vcpkg install asio:x64-windows
vcpkg install asio:arm64-uwp
vcpkg install asio:x64-uwp


mkdir tools\src
mkdir target\src

pushd tools
%PYTHONHOME%\Scripts\vcs.exe import src < ..\build_tools.repos
popd

pushd target
%PYTHONHOME%\Scripts\vcs.exe import src < ..\ros2_uwp.repos
xcopy /y src\ros2\orocos_kinematics_dynamics\orocos_kdl\config\FindEigen3.cmake src\ros2\eigen3_cmake_module\cmake\Modules
popd

pushd tools
call colcon build --merge-install --cmake-args -DBUILD_TESTING=OFF
popd

goto :eof

:novcpkg
echo "VCPkg not found at %VCPKG_ROOT%\vcpkg.exe"
dir c:\opt
