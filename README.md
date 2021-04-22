# ROS2 Native for UWP & Hololens
====================
This repository builds the native components as a nuget package or Unity Package Manager package required to support ROS2 on UWP devices and Hololens. The related project [ros_msft_mrtk](https://aka.ms/ros/mrtk), contains a Unity Project, ROS2.net utilities, and Mixed Reality Toolkit assets for Robotics. These projects can be used independently.

## Using the ROS2 Nuget in your UWP application
This project builds and publishes a nuget package named Microsoft.ROS.MRTK.<distro> to the nuget compatible Azure Artifact feed for ROS.

To consume the nuget package from a UWP application:

1. In Visual Studio, Add a nuget feed for `https://aka.ms/ros/public`.
1. locate Microsoft.ROS.MRTK.Foxy, and install it.
1. Now you can initialize it and perform pub/sub or use Action Servers.

A Native sample project for consuming the nuget package is available in the `examples` directory, allowing a UWP native application to consume ROS2 libraries directly.

## Using ROS2 from Unity
This project also builds and publishes a Unity Package Manager package to the npm compatible Azure Artifact Feed for ROS
To consume the output from a Unity application, follow the instructions on the [Unity documentation for adding a new feed](https://docs.unity3d.com/Manual/upm-ui.html), and installing `Microsoft.ROS.MRTK.Foxy` into your project.

