@echo off
setlocal enableextensions disabledelayedexpansion

if "%VSINSTALLDIR%" == "" (
    if exist "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community" (
        set "VSINSTALLDIR=C:\Program Files (x86)\Microsoft Visual Studio\2019\Community"
    )
    if exist "C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise" (
        set "VSINSTALLDIR=C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise"
    )
)    
echo "VSInstallDir is %VSINSTALLDIR%"

call "%VSINSTALLDIR%\VC\Auxiliary\Build\vcvars64.bat"

set NUSPEC="Microsoft.ROS.MRTK.Foxy"

pushd nuget

:: Parse options
:GETOPTS
 if /I "%~1" == "/?" goto USAGE
 if /I "%~1" == "/Help" goto USAGE
 if /I "%~1" == "/clean" set CLEAN=1
 if /I "%~1" == "/nopack" set NOPACK=1
 if /I "%~1" == "/arm" set NUSPEC="Microsoft.ROS.MRTK.Foxy.arm"
 if /I "%~1" == "/x86" set NUSPEC="Microsoft.ROS.MRTK.Foxy.x86"
 if /I "%~1" == "/x64" set NUSPEC="Microsoft.ROS.MRTK.Foxy.x64"
 if /I "%~1" == "/arm64" set NUSPEC="Microsoft.ROS.MRTK.Foxy.arm64"
 if /I "%~1" == "/unity" set NUSPEC="Microsoft.ROS.MRTK.Foxy.unity"
 shift
if not (%1)==() goto GETOPTS

echo Cleaning outputs
del %NUSPEC%.nupkg 2> NUL

:: if a clean was requested, exit here
if "%CLEAN%"=="1" goto end

:: skip packaging step if requested
if "%NOPACK%"=="1" goto end

echo Creating NuGet Package
nuget help > NUL
IF ERRORLEVEL 1 (
    echo Please install nuget.exe from http://nuget.org
    goto err
)

nuget pack %NUSPEC%.nuspec -NoPackageAnalysis || goto err

:end
popd

echo Success
exit /b 0

:err
  popd
  echo Script failed!
  exit /b 1