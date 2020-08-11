ros_msft_mrtk_native
====================
This repository contains supporting C wrappers for the [ros_msft_mrtk project](https://github.com/ms-iot/ros_msft_mrtk)

## Opencv4 Calibration Wrapper
This C wrapper exposes three functions for the explicit purpose of calibrating a new webcam using the [opencv checkerboard pattern](https://docs.opencv.org/3.1.0/pattern.png).

### Usage
1. Print out the checkerboard pattern. Ensure the image has not been rescaled in any way (the squares of the pattern must remain square). Ideally, tape the printed pattern down onto a rigid surface like cardboard.
2. Use your webcam to take pictures of the pattern, held at different angles and distances to the webcam. Feed each one to `supply_calibration_image(img*)` Each image currently expected to be in a single-channel, `CV_8UC1` format.
    * Note: images supplied to this opencv wrapper are caller-owned; supply only makes a shallow copy of the image. Do not deallocate the images supplied to `supply_calibration_image(img*)` until after calibration is completed.
3. Supply at least 15 varied images (more is better).
4. Use `calibrate()` to calculate and output the camera intrinsics using the information supplied by previous calls to `supply_calibration_image(img*)`
5. Once satisfied with the calibration results, call `clear_calibration_images()` to clear the wrapper of all supplied images. It is now safe for the caller to free supplied images.