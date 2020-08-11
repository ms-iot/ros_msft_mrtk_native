#pragma once

#include <opencv2/opencv.hpp>

typedef struct {
	int width;
	int height;
	int stride;

	unsigned char* buf;
} image_u8;

typedef struct {
	double fx;
	double fy;
	double cx;
	double cy;
} intrinsics;

#ifdef __cplusplus
extern "C" {
#endif

	/// <summary>
	/// Given img, attempts to find 
	/// the checkerboard calibration image. If successful, 
	/// appends the image to the calibration buffer
	/// </summary>
	/// <param name="img">one-channel 8 byte image</param>
	/// <returns>the number of images currently in the calibration buffer</returns>
	__declspec(dllexport)
	int __cdecl supply_calibration_image(image_u8* img);

	/// <summary>
	/// Clears the calibration buffer
	/// </summary>
	/// <returns>the number of images currently in the calibration buffer</returns>
	__declspec(dllexport)
	int __cdecl clear_calibration_images();

	/// <summary>
	/// Uses the current calibration buffer to compute the camera intrinsics
	/// </summary>
	/// <param name="squareSize">the size in meters of a checker on the printed calibration board</param>
	/// <param name="outputIntrinsics">A caller-allocated intrinsics struct output variable. This function populates it.</param>
	/// <returns>whether or not the calibration succeeded (requires enough calibration images)</returns>
	__declspec(dllexport)
	bool __cdecl calibrate(float squareSize, intrinsics* outputIntrinsics);

#ifdef __cplusplus
}
#endif