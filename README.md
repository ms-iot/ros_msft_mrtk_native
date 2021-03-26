# ROS2 Native for UWP & Hololens
====================
This repository builds the native components as a nuget package or Unity Package Manager package required to support ROS2 on UWP devices and Hololens. The related project [ros_msft_mrtk](https://github.com/ms-iot/ros_msft_mrtk), contains a Unity Project, ROS2.net utilities, and Mixed Reality Toolkit assets for Robotics. These projects can be used independently.

## Using the ROS2 Nuget in your UWP application
This project builds and publishes a nuget package named Microsoft.ROS.MRTK.<distro> to the nuget compatible Azure Artifact feed for ROS.

To consume the nuget package from a UWP application:

1. In Visual Studio, Add a nuget feed for `https://aka.ms/ros/public`.
1. locate Microsoft.ROS.MRTK.Foxy, and install it.
1. Now you can initialize it and perform pub/sub or use Action Servers.

A Sample project is **coming soon**.

## Using ROS2 from Unity
This project also builds and publishes a Unity Package Manager package to the npm compatible Azure Artifact Feed for ROS
To consume the output from a Unity application, follow the instructions on the [Unity documentation for adding a new feed](https://docs.unity3d.com/Manual/upm-ui.html), and installing `Microsoft.ROS.MRTK.Foxy` into your project.




## Opencv4 Calibration Tool
This C wrapper exposes three functions for the explicit purpose of calibrating a new webcam using the [opencv checkerboard pattern](https://docs.opencv.org/3.1.0/pattern.png).

### Usage
1. Print out the checkerboard pattern. Ensure the image has not been rescaled in any way (the squares of the pattern must remain square). Ideally, tape the printed pattern down onto a rigid surface like cardboard.
2. Use your webcam to take pictures of the pattern, held at different angles and distances to the webcam. Feed each one to `supply_calibration_image(img*)` Each image currently expected to be in a single-channel, `CV_8UC1` format.
    * Note: images supplied to this opencv wrapper are caller-owned; supply only makes a shallow copy of the image. Do not deallocate the images supplied to `supply_calibration_image(img*)` until after calibration is completed.
3. Supply at least 15 varied images (more is better).
4. Use `calibrate()` to calculate and output the camera intrinsics using the information supplied by previous calls to `supply_calibration_image(img*)`
5. Once satisfied with the calibration results, call `clear_calibration_images()` to clear the wrapper of all supplied images. It is now safe for the caller to free supplied images.
