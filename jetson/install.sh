#!/bin/bash

echo "Build and install OpenCV in Jetson."

INSTALL_DIR=/opt/opencv4.x/build
CMAKE_INSTALL_PREFIX=$INSTALL_DIR

HOME=/home/nvidia/
PYTHON3_EXECUTABLE=/usr/bin/python3
OPENCV_SOURCE_DIR=$HOME/opencv4.x/opencv_4.x
OPENCV_CONTRIB_SOURCE_DIR=$HOME/opencv4.x/opencv_contrib_4.x/modules
OPENCV_PKG_PATH=${INSTALL_DIR}/lib/pkgconfig/opencv.pc

echo "Build configuration: "
echo " OpenCV Source Path: $OPENCV_SOURCE_DIR"
echo " OpenCV Contrib Path: $OPENCV_CONTRIB_SOURCE_DIR"
echo " OpenCV binaries will be installed in: $INSTALL_DIR"
echo " OpenCV pkgconfig path: $OPENCV_PKG_PATH"
echo " Python3 executable: $PYTHON3_EXECUTABLE"


echo "Install python3 dependency..."
sudo apt-get install -y python3-dev python3-numpy python3-py python3-pytest
echo "Install python3 dependency done."

echo "Install GStream..."
sudo apt-get install -y libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev 
echo "Install GStream done."

cd $OPENCV_SOURCE_DIR
mkdir build
cd build

#Read Jetson Version
if [ -f /sys/module/tegra_fuse/parameters/tegra_chip_id ]; then
    case $(cat /sys/module/tegra_fuse/parameters/tegra_chip_id) in
        64)
            JETSON_BOARD="TK1" ;;
        33)
            JETSON_BOARD="TX1" ;;
        24)
            JETSON_BOARD="TX2" ;;
        25) 
            JETSON_BOARD="Xavier" ;;
        *)
            JETSON_BOARD="UNKNOWN" ;;
    esac
    JETSON_DESCRIPTION="NVIDIA Jetson $JETSON_BOARD"
fi

#Read Jetpack info
if [ -f /etc/nv_tegra_release ]; then
    # L4T string
    JETSON_L4T_STRING=$(head -n 1 /etc/nv_tegra_release)

    # Load release and revision
    JETSON_L4T_RELEASE=$(echo $JETSON_L4T_STRING | cut -f 1 -d ',' | sed 's/\# R//g' | cut -d ' ' -f1)
    JETSON_L4T_REVISION=$(echo $JETSON_L4T_STRING | cut -f 2 -d ',' | sed 's/\ REVISION: //g' )
    # unset variable
    unset JETSON_L4T_STRING
    
    # Write Jetson description
    JETSON_L4T="$JETSON_L4T_RELEASE.$JETSON_L4T_REVISION"

    # Write version of jetpack installed
    # https://developer.nvidia.com/embedded/jetpack-archive
    if [ "$JETSON_BOARD" = "Xavier" ] ; then 
        case $JETSON_L4T in
            "31.0.1")
                    JETSON_JETPACK="4.0 DP" ;;
            "31.0.2")
                    JETSON_JETPACK="4.1 DP" ;;
            *)
               JETSON_JETPACK="UNKNOWN" ;;
        esac        
    elif [ "$JETSON_BOARD" = "TX2i" ] ; then 
        case $JETSON_L4T in
            "28.2.1")
                    JETSON_JETPACK="3.3 or 3.2.1" ;;
            "28.2") 
               JETSON_JETPACK="3.2" ;;
            *)
               JETSON_JETPACK="UNKNOWN" ;;
        esac        
    elif [ "$JETSON_BOARD" = "TX2" ] ; then
        case $JETSON_L4T in
            "28.2.1")
                    JETSON_JETPACK="3.3 or 3.2.1" ;;
            "28.2") 
                    JETSON_JETPACK="3.2" ;;
            "28.1") 
                    JETSON_JETPACK="3.1" ;;
            "27.1") 
                    JETSON_JETPACK="3.0" ;;
            *)
               JETSON_JETPACK="UNKNOWN" ;;
        esac
    elif [ "$JETSON_BOARD" = "TX1" ] ; then
        case $JETSON_L4T in
            "28.2.0")
                    JETSON_JETPACK="3.3" ;;
            "28.2") 
                    JETSON_JETPACK="3.2 or 3.2.1" ;;
            "28.1") 
                    JETSON_JETPACK="3.1" ;;
            "24.2.1") 
                    JETSON_JETPACK="3.0 or 2.3.1" ;;
            "24.2") 
                    JETSON_JETPACK="2.3" ;;
            "24.1") 
                    JETSON_JETPACK="2.2.1 or 2.2" ;;
            "23.2") 
                    JETSON_JETPACK="2.1" ;;
            "23.1") 
                    JETSON_JETPACK="2.0" ;;
            *)
               JETSON_JETPACK="UNKNOWN" ;;
        esac
    elif [ "$JETSON_BOARD" ="TK1" ] ; then
        case $JETSON_L4T in
            "21.5") 
                    JETSON_JETPACK="2.3.1 or 2.3" ;;
            "21.4") 
                    JETSON_JETPACK="2.2 or 2.1 or 2.0 or DP 1.2" ;;
            "21.3") 
                    JETSON_JETPACK="DP 1.1" ;;
            "21.2") 
                    JETSON_JETPACK="DP 1.0" ;;
            *)
               JETSON_JETPACK="UNKNOWN" ;;
        esac
    else
        # Unknown board
        JETSON_JETPACK="UNKNOWN"
    fi
fi

#Read CUDA Version
if [ -f /usr/local/cuda/version.txt ]; then
    JETSON_CUDA=$(cat /usr/local/cuda/version.txt | sed 's/\CUDA Version //g')
else
    JETSON_CUDA="NOT INSTALLED"
fi

# Read opencv version
pkg-config --exists opencv
if [ $? == "0" ] ; then
    JETSON_OPENCV=$(pkg-config --modversion opencv)
else
    JETSON_OPENCV="NOT INSTALLED"
fi

#Run this:
#cd /usr/local/cuda/samples/1_Utilities/deviceQuery
#sudo make
#./deviceQuery
ARCH_BIN=7.2

echo " NVIDIA Jetson $JETSON_BOARD"
echo " Operating System: $JETSON_L4T_STRING [Jetpack $JETSON_JETPACK]"
echo " NVIDIA ARCH BIN: $ARCH_BIN"
echo " NVIDIA CUDA: $JETSON_CUDA"
echo " NVIDIA Jetson OpenCV: $JETSON_OPENCV"

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


# function run_cmake(){
#   time cmake \
#   -D CMAKE_BUILD_TYPE=RELEASE \
#   -D OPENCV_GENERATE_PKGCONFIG=ON \
#   -D CMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} \
#   -D OPENCV_EXTRA_MODULES_PATH=${OPENCV_CONTRIB_SOURCE_DIR} \
#   -D PYTHON3_EXECUTABLE=${PYTHON3_EXECUTABLE} \
#   -D INSTALL_C_EXAMPLES=OFF \
#   -D INSTALL_PYTHON_EXAMPLES=ON \
#   -D BUILD_NEW_PYTHON_SUPPORT=ON \
#   -D BUILD_opencv_python3=ON \
#   -D BUILD_EXAMPLES=ON \
#   -D WITH_OPENJPEG=OFF \
#   -D WITH_IPP=OFF \
#   -D WITH_TBB=ON \
#   -D OPENCV_ENABLE_NONFREE=ON \
#   -D ENABLE_FAST_MATH=ON \
#   -D WITH_LIBV4L=ON \
#   -D WITH_OPENGL=ON \
#   -D CUDA_ARCH_BIN=${ARCH_BIN} \
#   -D CUDA_ARCH_PTX="" \
#   -D CUDA_FAST_MATH=ON \
#   -D WITH_CUBLAS=ON \
#   -D CUDA_NVCC_FLAGS="--expt-relaxed-constexpr" \
#   -D WITH_GSTREAMER=ON \
#   -D WITH_GSTREAMER_0_10=OFF \
#   ../

#   if [ $? -eq 0 ] ; then
#     echo "CMake configuration make successful"
#   else
#     echo "CMake issues " >&2
#     echo "Please check the configuration being used"
#     exit 1
#   fi
# }

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
  -D CUDA_NVCC_FLAGS="--expt-relaxed-constexpr" \
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


function run_cmake(){
  time cmake \
  -D CMAKE_BUILD_TYPE=RELEASE \
  -D OPENCV_GENERATE_PKGCONFIG=ON \
  -D CMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} \
  -D OPENCV_EXTRA_MODULES_PATH=${OPENCV_CONTRIB_SOURCE_DIR} \
  -D CUDA_ARCH_BIN=${ARCH_BIN} \
  -D CUDA_ARCH_PTX="" \
  -D CUDA_FAST_MATH=ON \
  -D CUDA_NVCC_FLAGS="--expt-relaxed-constexpr" \
  -D WITH_CUBLAS=ON \
  -D WITH_CUDA=ON \
  -D WITH_NVCUVID=ON \
  -D PYTHON3_EXECUTABLE=${PYTHON3_EXECUTABLE} \
  -D BUILD_opencv_python3=ON \
  -D BUILD_NEW_PYTHON_SUPPORT=ON \
  -D INSTALL_C_EXAMPLES=OFF \
  -D INSTALL_PYTHON_EXAMPLES=ON \
  -D ENABLE_FAST_MATH=ON \
  -D WITH_TBB=OFF \
  -D WITH_IPP=OFF \
  -D WITH_LIBV4L=ON \
  -D WITH_OPENGL=ON \
  -D WITH_GSTREAMER=ON \
  -D WITH_GSTREAMER_0_10=OFF \
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

function make_opencv(){
  NUM_CPU=$(nproc)
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
# run_cmake
# make_opencv
# make_install

echo "pkg-config --cflags opencv4:"
echo $(pkg-config --cflags opencv4)

echo "pkg-config --libs opencv4:"
echo $(pkg-config --libs opencv4)
