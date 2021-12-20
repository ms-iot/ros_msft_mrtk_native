# ROS2 Native for UWP & Hololens [**Preview**]
> NOTE: This project is under active development. 

This repository builds the native components as a nuget package or Unity Package Manager package required to support ROS2 on UWP devices and Hololens. The related project [ros_msft_mrtk](https://aka.ms/ros/mrtk), contains a Unity Project, ROS2.net utilities, and Mixed Reality Toolkit assets for Robotics. These projects can be used independently.

## Using the ROS2 Nuget in your UWP application
This project builds a nuget package named Microsoft.ROS.MRTK.<distro> available from the github release on this repository. 

To consume the nuget package from a UWP application:

1. Download the native nuget package from the github release.
1. Move the downloaded nuget package to a folder on your computer.
1. In Visual Studio, Create a `local` Nuget Feed by selecting `Tools` -> `Nuget Package Manager` -> `Package Manager Settings`, then selecting `Package Sources`.
1. Locate Microsoft.ROS.MRTK.Foxy, and install it from the Nubet Package Manager.
1. Now you can initialize it and perform pub/sub or use Action Client.

A Native sample project for consuming the nuget package is available in the `examples` directory, allowing a UWP native application to consume ROS2 libraries directly.

## Using ROS2 from Unity
This project also builds and publishes a Unity Package Manager package to the npm compatible Azure Artifact Feed for ROS
To consume the output from a Unity application, follow the instructions on the [Unity documentation for adding a new feed](https://docs.unity3d.com/Manual/upm-ui.html), and installing `Microsoft.ROS.MRTK.Foxy` into your project.

# Building from Source
Building ROS2 & ROS2.net for UWP requires multiple passes, ultimately generating a nuget package or Unity package manager package. 

## Prerequistes
Please [install ROS2 Foxy for Windows](http://aka.ms/ros/setup_ros2) according to the instructions. (Some of the ROS tooling is required and referenced during the builds.)

Create a shortcut for building *without a ROS2* environment, such as:
```cmd
C:\Windows\System32\cmd.exe /k "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\Tools\VsDevCmd.bat" -arch=amd64 -host_arch=amd64
```

## VCPKG
This repo depends on vcpkg being checked out into `c:\opt`:

``` cmd
mkdir c:\opt
cd c:\opt
git clone https://github.com/ooeygui/vcpkg
```

## Initializing your source tree.
``` cmd
mkdir c:\ws
cd c:\ws
git clone -b foxy https://github.com/ms-iot/ros_msft_mrtk_native
cd c:\ws\ros_msft_mrtk_native
inittree.cmd
```

## Building the tools
If you only intend to target one architecture, you can pass one of `/x86`, `/x64`, `/arm`, `/arm64`, `/unity`. Passing no argument will instruct the build scripts to generate binaries for all platforms. The `/unity` flag creates a build of ROS2 which works within the Unity Editor or Windows Desktop Mixed Reality Application.

 
``` cmd
initvcpkg.cmd [/x86 | /x64 | /arm | /arm64 | /unity]
inittools.cmd [/x86 | /x64 | /arm | /arm64 | /unity]
```

## Building ROS2 & ROS2.net
> NOTE: there is a sequencing problem with message generation and the .net generator; you may need to build the tree twice to generate messages.

``` cmd
build.cmd [/x86 | /x64 | /arm | /arm64 | /unity]
```

## Building Nuget

``` cmd
build_nuget.cmd [/x86 | /x64 | /arm | /arm64 | /unity]
```

## Building UPM for Unity

``` cmd
build_upm.cmd [/x86 | /x64 | /arm | /arm64 | /unity]
```

# Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.microsoft.com.

When you submit a pull request, a CLA-bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., label, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

# Special Thanks
This project is built on the amazing work by Open Robotics, the ROS2 technical steering committee, eProsima, the ROS2.net developers, and the ROS community.
