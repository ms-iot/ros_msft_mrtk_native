
#include "Calibration.h"

using namespace cv;
using namespace std;

const Size BOARD_SIZE = Size(9, 6);
const int MINIMUM_CALIBRATION_IMAGES = 15;

vector<Mat> savedImages;
vector<vector<Point2f>> imagePoints;

void getKnownCorners(Size boardSize, float squareSize, vector<Point3f>& corners) {
	for (int i = 0; i < boardSize.height; i++) {
		for (int j = 0; j < boardSize.width; j++) {
			corners.push_back(Point3f(j * squareSize, i * squareSize, 0.0f));
		}
	}
}

int supply_calibration_image(image_u8* img) {
	Mat mat = Mat(img->height, img->stride, CV_8UC1, img->buf);  // assumes no padding; cols*elSize
	vector<Point2f> corners;
	bool found = findChessboardCorners(mat, BOARD_SIZE, corners, CALIB_CB_FAST_CHECK | CALIB_CB_NORMALIZE_IMAGE);
	if (found) {
		savedImages.push_back(mat);
		imagePoints.push_back(corners);
	}

	return savedImages.size();
}

int clear_calibration_images() {
	savedImages.clear();
	imagePoints.clear();

	return savedImages.size();
}

bool calibrate(float squareSize, intrinsics* outputIntrinsics) {
	if (savedImages.size() < MINIMUM_CALIBRATION_IMAGES) {
		return false;
	}

	vector<vector<Point3f>> objectPoints(1);
	getKnownCorners(BOARD_SIZE, squareSize, objectPoints[0]);
	objectPoints.resize(imagePoints.size(), objectPoints[0]);

	vector<Mat> rVectors, tVectors;
	Mat distanceCoefficients = Mat::zeros(8, 1, CV_64F);

	Mat cameraMatrix;

	calibrateCamera(objectPoints, imagePoints, BOARD_SIZE, cameraMatrix, distanceCoefficients, rVectors, tVectors);

	outputIntrinsics->fx = cameraMatrix.at<double>(0, 0);
	outputIntrinsics->fy = cameraMatrix.at<double>(1, 1);
	outputIntrinsics->cx = cameraMatrix.at<double>(0, 2);
	outputIntrinsics->cy = cameraMatrix.at<double>(1, 2);

	return true;
}