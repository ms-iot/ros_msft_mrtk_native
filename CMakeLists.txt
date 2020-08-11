cmake_minimum_required(VERSION 3.1)
project(opencv-c-wrapper LANGUAGES C CXX)

find_package(OpenCV REQUIRED)
include_directories(${OpenCV_INCLUDE_DIRS})

set(CMAKE_BUILD_TYPE Release)


add_library(${PROJECT_NAME} SHARED Calibration.cpp)

target_link_libraries(${PROJECT_NAME} PRIVATE
 ${OpenCV_LIBRARIES}
)

install(TARGETS ${PROJECT_NAME} EXPORT opencv-c-wrapper
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    
)

set(WRAPPER_HEADERS Calibration.h)

install(FILES ${WRAPPER_HEADERS} DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/${PROJECT_NAME})

install(EXPORT opencv-c-wrapper
    DESTINATION share/opencv-c-wrapper/cmake
    FILE opencv-c-wrapperConfig.cmake
)