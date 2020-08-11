cmake_minimum_required(VERSION 3.1)
project(ros-msft-mrtk-native LANGUAGES C CXX)

find_package(OpenCV REQUIRED)
include_directories(${OpenCV_INCLUDE_DIRS})

set(CMAKE_BUILD_TYPE Release)


add_library(${PROJECT_NAME} SHARED Calibration.cpp)

target_link_libraries(${PROJECT_NAME} PRIVATE
 ${OpenCV_LIBRARIES}
)

install(TARGETS ${PROJECT_NAME} EXPORT ros-msft-mrtk-native
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    
)

set(WRAPPER_HEADERS Calibration.h)

install(FILES ${WRAPPER_HEADERS} DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/${PROJECT_NAME})

install(EXPORT ros-msft-mrtk-native
    DESTINATION share/ros-msft-mrtk-native/cmake
    FILE ros-msft-mrtk-nativeConfig.cmake
)