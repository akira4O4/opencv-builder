#!/bin/bash

echo "Build and install OpenCV in MacOS."

INSTALL_DIR=/opt/opencv/build
CMAKE_INSTALL_PREFIX=$INSTALL_DIR

PYTHON3_EXECUTABLE=/Users/lee/miniforge3/envs/torch/bin/python3
OPENCV_SOURCE_DIR=/Users/lee/Desktop/github_download/opencv/opencv_4.x
OPENCV_CONTRIB_SOURCE_DIR=/Users/lee/Desktop/github_download/opencv/opencv_contrib_4.x/modules
OPENCV_PKG_PATH=${INSTALL_DIR}/lib/pkgconfig/opencv.pc
OPENCV_CMAKE_PATH=${INSTALL_DIR}/lib/cmake/opencv4

echo "Build configuration: "
echo " OpenCV Source will be installed in: $OPENCV_SOURCE_DIR"
echo " OpenCV Contrib Source will be installed in: $OPENCV_CONTRIB_SOURCE_DIR"
echo " OpenCV binaries will be installed in: $INSTALL_DIR"
echo " OpenCV pkgconfig path: $OPENCV_PKG_PATH"
echo " OpenCV cmake path: $OPENCV_CMAKE_PATH"
echo " Python3 executable: $PYTHON3_EXECUTABLE"

cd $OPENCV_SOURCE_DIR
# mkdir build
cd build

function run_cmake(){
  time cmake \
  -D CMAKE_BUILD_TYPE=RELEASE \
  -D CMAKE_OSX_ARCHITECTURES=arm64 \
  -D CMAKE_SYSTEM_PROCESSOR=arm64 \
  -D OPENCV_GENERATE_PKGCONFIG=ON \
  -D CMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} \
  -D OPENCV_EXTRA_MODULES_PATH=${OPENCV_CONTRIB_SOURCE_DIR} \
  -D PYTHON3_EXECUTABLE=${PYTHON3_EXECUTABLE} \
  -D INSTALL_PYTHON_EXAMPLES=ON \
  -D BUILD_opencv_python3=ON \
  -D WITH_OPENJPEG=OFF \
  -D WITH_IPP=OFF \
  -D WITH_TBB=ON \
  -D INSTALL_C_EXAMPLES=OFF \
  -D OPENCV_ENABLE_NONFREE=ON \
  -D BUILD_EXAMPLES=ON \
  -D ENABLE_FAST_MATH=ON \
  -D WITH_LIBV4L=ON \
  -D WITH_OPENGL=ON \
  ../

  if [ $? -eq 0 ] ; then
    echo "CMake configuration make successful"
  else
    echo "CMake issues " >&2
    echo "Please check the configuration being used"
    exit 1
  fi
}

function make_opencv(){
  NUM_CPU=8
  echo "NUM_CPU: $NUM_CPU"
  echo "NUM_CPU: $(sysctlhw.physicalcpu)"

  time make -j$($NUM_CPU)

  if [ $? -eq 0 ] ; then
    echo "OpenCV make successful"

  else
    echo "Make did not build " >&2
    echo "Retrying ... "
  
    make
    if [ $? -eq 0 ] ; then
      echo "OpenCV make successful"
  
    else
      echo "Make did not successfully build" >&2
      echo "Please fix issues and retry build"
      exit 1
    fi
  fi

}

function make_install(){
    echo "Installing ... "
  sudo make install
  if [ $? -eq 0 ] ; then
    echo "OpenCV installed in: $CMAKE_INSTALL_PREFIX"
  else
    echo "There was an issue with the final installation"
    exit 1
  fi
}

run_cmake
make_opencv
make_install

echo "pkg-config --cflags opencv4:"
echo $(pkg-config --cflags opencv4)

echo "pkg-config --libs opencv4:"
echo $(pkg-config --libs opencv4)

echo "Write this command to .bashrc or .zshrc"
echo 'export PKG_CONFIG_PATH=$OPENCV_CONTRIB_SOURCE_DIR:$PKG_CONFIG_PATH'
echo 'export LD_LIBRARY_PATH=$INSTALL_DIR/lib:$LD_LIBRARY_PATH'
echo 'export PATH=$OPENCV_CMAKE_PATH:$PATH'