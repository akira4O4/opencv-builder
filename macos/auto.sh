#!/bin/bash

echo "Build and install OpenCV in MacOS."

INSTALL_DIR=/opt/opencv/build
CMAKE_INSTALL_PREFIX=$INSTALL_DIR

PYTHON3_EXECUTABLE=/Users/lee/miniforge3/envs/torch/bin/python3
OPENCV_SOURCE_DIR=/Users/lee/Desktop/github_download/opencv/opencv_4.x
OPENCV_CONTRIB_SOURCE_DIR=/Users/lee/Desktop/github_download/opencv/opencv_contrib_4.x/modules
OPENCV_PKG_PATH=/opt/opencv/build/lib/pkgconfig/opencv.pc

echo "Build configuration: "
echo " OpenCV Source will be installed in: $OPENCV_SOURCE_DIR"
echo " OpenCV Contrib Source will be installed in: $OPENCV_CONTRIB_SOURCE_DIR"
echo " OpenCV binaries will be installed in: $INSTALL_DIR"
echo " OpenCV pkgconfig path: $OPENCV_PKG_PATH"
echo " Python3 executable: $PYTHON3_EXECUTABLE"


cd $OPENCV_SOURCE_DIR
mkdir build
cd build

function dependency(){
  sudo apt-add-repository universe
  sudo apt-get update

  echo "Download the dependency..."
  sudo brew install \
    build-essential \
    libgtk2.0-dev \
    cmake \
    python3-dev \
    python3-numpy \
    libtbb2 \
    libtiff-dev \
    libjasper-dev \
    libdc1394-22-dev 
    libavcodec-dev \
    libavformat-dev \
    libavutil-dev \
    libeigen3-dev \
    libglew-dev \
    libgtk2.0-dev \
    libgtk-3-dev \
    libjpeg-dev \
    libpng-dev \
    libpostproc-dev \
    libswscale-dev \
    libtbb-dev \
    libtiff5-dev \
    libv4l-dev \
    libxvidcore-dev \
    libx264-dev \
    qt5-default \
    zlib1g-dev \
    libgl1 \
    libglvnd-dev \
    pkg-config \
    liblapacke-dev \
    libatlas-base-dev \
    gfortran \
    ffmpeg  


}

function cmake(){
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
}

function make(){
  NUM_CPU=8
  echo "NUM_CPU: $NUM_CPU"

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

function install(){
    echo "Installing ... "
  sudo make install
  if [ $? -eq 0 ] ; then
    echo "OpenCV installed in: $CMAKE_INSTALL_PREFIX"
  else
    echo "There was an issue with the final installation"
    exit 1
  fi
}

# dependency
# cmake
# make
# install

echo ""
echo "pkg-config --cflags opencv4:"
echo $(pkg-config --cflags opencv4)
echo ""
echo "pkg-config --libs opencv4:"
echo $(pkg-config --libs opencv4)
echo ""