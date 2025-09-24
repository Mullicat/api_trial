# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION 3.22.1-g37088a8-dirty)

# We name the project and the target for the ExternalProject_Add() call
# to something that will highlight to the user what we are working on if
# something goes wrong and an error message is produced.

project(libopencv-populate NONE)



include(ExternalProject)
ExternalProject_Add(libopencv-populate
                     "UPDATE_DISCONNECTED" "False" "URL" "https://github.com/rainyl/opencv.full/releases/download/4.12.0.0/libopencv-android-armeabi-v7a.tar.gz"
                    SOURCE_DIR          "C:/WorkFiles/MulliCat/API_Trial/api_trial/third_party/opencv_dart-1.4.3/android/.cxx/Release/675f6ba4/armeabi-v7a/_deps/libopencv-src"
                    BINARY_DIR          "C:/WorkFiles/MulliCat/API_Trial/api_trial/third_party/opencv_dart-1.4.3/android/.cxx/Release/675f6ba4/armeabi-v7a/_deps/libopencv-build"
                    CONFIGURE_COMMAND   ""
                    BUILD_COMMAND       ""
                    INSTALL_COMMAND     ""
                    TEST_COMMAND        ""
                    USES_TERMINAL_DOWNLOAD  YES
                    USES_TERMINAL_UPDATE    YES
)


