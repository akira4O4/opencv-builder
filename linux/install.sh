#!/bin/bash

echo "Build and install OpenCV in Linux."

INSTALL_DIR=/opt/opencv/build
CMAKE_INSTALL_PREFIX=$INSTALL_DIR

HOME=/home/ubuntu

PYTHON3_EXECUTABLE=$HOME/anaconda3/envs/torch/bin/python
OPENCV_SOURCE_DIR=$HOME/opencv4.x/opencv
OPENCV_CONTRIB_SOURCE_DIR=$HOME/opencv4.x/opencv_contrib/modules
OPENCV_PKG_PATH=${INSTALL_DIR}/lib/pkgconfig/opencv.pc
OPENCV_CMAKE_PATH=${INSTALL_DIR}/lib/cmake/opencv4

echo "Install python3 dependency..."
sudo apt-get install -y python3-dev python3-numpy python3-py python3-pytest
echo "Install python3 dependency done."

echo "Install GStream..."
sudo apt-get install -y libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev 
echo "Install GStream done."

#Run this:
#cd /usr/local/cuda/samples/1_Utilities/deviceQuery
#sudo make
#./deviceQuery

ARCH_BIN=7.2
echo "Build configuration: "
echo " OpenCV Source Path: $OPENCV_SOURCE_DIR"
echo " OpenCV Contrib Path: $OPENCV_CONTRIB_SOURCE_DIR"
echo " OpenCV binaries will be installed in: $INSTALL_DIR"
echo " OpenCV pkgconfig path: $OPENCV_PKG_PATH"
echo " OpenCV cmake path: $OPENCV_CMAKE_PATH"
echo " CUDA BIN: $ARCH_BIN"
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

#NO CUDA
#NO GStream
function run_cmake_Norm(){
  time cmake \
  -D CMAKE_BUILD_TYPE=RELEASE \
  -D OPENCV_GENERATE_PKGCONFIG=ON \
  -D CMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} \
  -D OPENCV_EXTRA_MODULES_PATH=${OPENCV_CONTRIB_SOURCE_DIR} \
  -D PYTHON3_EXECUTABLE=${PYTHON3_EXECUTABLE} \
  -D INSTALL_C_EXAMPLES=OFF \
  -D INSTALL_PYTHON_EXAMPLES=ON \
  -D BUILD_NEW_PYTHON_SUPPORT=ON \
  -D BUILD_opencv_python2=OFF \
  -D BUILD_opencv_python3=ON \
  -D ENABLE_FAST_MATH=ON \
  -D BUILD_EXAMPLES=ON \
  -D BUILD_TESTS=OFF \
  -D BUILD_PREF_TESTS=OFF \
  -D WITH_IPP=OFF \
  -D WITH_TBB=OFF \
  -D WITH_OPENJPEG=OFF \
  -D WITH_LIBV4L=ON \
  -D WITH_V4L=ON \
  -D WITH_OPENGL=ON \
  -D OPENCV_ENABLE_NONFREE=ON \
  ../

  if [ $? -eq 0 ] ; then
    echo "CMake configuration make successful without CUDA and GStream."
  else
    echo "CMake issues " >&2
    echo "Please check the configuration being used"
    exit 1
  fi
}

function run_cmake_CUDA(){
  time cmake \
  -D CMAKE_BUILD_TYPE=RELEASE \
  -D OPENCV_GENERATE_PKGCONFIG=ON \
  -D CMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} \
  -D OPENCV_EXTRA_MODULES_PATH=${OPENCV_CONTRIB_SOURCE_DIR} \
  -D PYTHON3_EXECUTABLE=${PYTHON3_EXECUTABLE} \
  -D INSTALL_C_EXAMPLES=OFF \
  -D INSTALL_PYTHON_EXAMPLES=ON \
  -D BUILD_NEW_PYTHON_SUPPORT=ON \
  -D BUILD_opencv_python3=ON \
  -D ENABLE_FAST_MATH=ON \
  -D BUILD_EXAMPLES=ON \
  -D BUILD_TESTS=OFF \
  -D BUILD_PREF_TESTS=OFF \
  -D CUDA_ARCH_BIN=$ARCH_BIN \
  -D CUDA_ARCH_PTX="" \
  -D CUDA_FAST_MATH=ON \
  -D WITH_CUDA=ON \
  -D WITH_CUBLAS=ON \
  -D WITH_NVCUVID=OFF \
  -D WITH_IPP=OFF \
  -D WITH_TBB=OFF \
  -D WITH_OPENJPEG=OFF \
  -D WITH_LIBV4L=ON \
  -D WITH_V4L=ON \
  -D WITH_OPENGL=ON \
  -D OPENCV_ENABLE_NONFREE=ON \
  ../

  if [ $? -eq 0 ] ; then
    echo "CMake configuration make successful"
  else
    echo "CMake issues " >&2
    echo "Please check the configuration being used"
    exit 1
  fi
}

function run_cmake_GStream(){
  time cmake \
  -D CMAKE_BUILD_TYPE=RELEASE \
  -D OPENCV_GENERATE_PKGCONFIG=ON \
  -D CMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} \
  -D OPENCV_EXTRA_MODULES_PATH=${OPENCV_CONTRIB_SOURCE_DIR} \
  -D PYTHON3_EXECUTABLE=${PYTHON3_EXECUTABLE} \
  -D INSTALL_C_EXAMPLES=OFF \
  -D INSTALL_PYTHON_EXAMPLES=ON \
  -D BUILD_NEW_PYTHON_SUPPORT=ON \
  -D BUILD_opencv_python3=ON \
  -D ENABLE_FAST_MATH=ON \
  -D BUILD_EXAMPLES=ON \
  -D BUILD_TESTS=OFF \
  -D BUILD_PREF_TESTS=OFF \
  -D WITH_IPP=OFF \
  -D WITH_TBB=OFF \
  -D WITH_OPENJPEG=OFF \
  -D WITH_LIBV4L=ON \
  -D WITH_V4L=ON \
  -D WITH_OPENGL=ON \
  -D WITH_GSTREAMER=ON \
  -D WITH_GSTREAMER_0_10=OFF \
  -D OPENCV_ENABLE_NONFREE=ON \
  ../

  if [ $? -eq 0 ] ; then
    echo "CMake configuration make successful with GStream."
  else
    echo "CMake issues " >&2
    echo "Please check the configuration being used"
    exit 1
  fi
}

function run_cmake_CUDA_GStream(){
  time cmake \
  -D CMAKE_BUILD_TYPE=RELEASE \
  -D OPENCV_GENERATE_PKGCONFIG=ON \
  -D CMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} \
  -D OPENCV_EXTRA_MODULES_PATH=${OPENCV_CONTRIB_SOURCE_DIR} \
  -D PYTHON3_EXECUTABLE=${PYTHON3_EXECUTABLE} \
  -D INSTALL_C_EXAMPLES=OFF \
  -D INSTALL_PYTHON_EXAMPLES=ON \
  -D BUILD_NEW_PYTHON_SUPPORT=ON \
  -D BUILD_opencv_python3=ON \
  -D ENABLE_FAST_MATH=ON \
  -D BUILD_EXAMPLES=ON \
  -D BUILD_TESTS=OFF \
  -D BUILD_PREF_TESTS=OFF \
  -D CUDA_ARCH_BIN=$ARCH_BIN \
  -D CUDA_ARCH_PTX="" \
  -D CUDA_FAST_MATH=ON \
  -D WITH_CUDA=ON \
  -D WITH_CUBLAS=ON \
  -D WITH_NVCUVID=OFF \
  -D WITH_IPP=OFF \
  -D WITH_TBB=OFF \
  -D WITH_OPENJPEG=OFF \
  -D WITH_LIBV4L=ON \
  -D WITH_V4L=ON \
  -D WITH_OPENGL=ON \
  -D WITH_GSTREAMER=ON \
  -D WITH_GSTREAMER_0_10=OFF \
  -D OPENCV_ENABLE_NONFREE=ON \
  ../

  if [ $? -eq 0 ] ; then
    echo "CMake configuration make successful with CUDA And GStream"
  else
    echo "CMake issues " >&2
    echo "Please check the configuration being used"
    exit 1
  fi
}



function make_opencv(){
  NUM_CPU=16
  echo "NUM_CPU: $NUM_CPU"
  
  time make -j$NUM_CPU

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

# dependency
# run_cmake_Norm
# run_cmake_GStream
# run_cmake_CUDA
run_cmake_CUDA_GStream
make_opencv
make_install

echo "pkg-config --cflags opencv4:"
echo $(pkg-config --cflags opencv4)

echo "pkg-config --libs opencv4:"
echo $(pkg-config --libs opencv4)
