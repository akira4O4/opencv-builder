#args setting.
build_type=RELEASE

version=4.x
root=/home/akira/opencv-${version}
install_prefix=/opt/opencv-${version}/build
python_interpreter=/home/akira/mambaforge/bin/python
num_of_cpu=12

#Auto
opencv_dir=${root}/opencv
opencv_contrib_dir=${root}/opencv_contrib
build_dir=${opencv_dir}/build
cmake_file_path=${opencv_dir}

echo "Opencv Dir        : ${opencv_dir}"
echo "Opencv Contrib Dir: ${opencv_contrib_dir}"
echo "Install Dir       : ${install_prefix}"

sleep 2


#------------------------------------------------------------------------------
#check and create build dir
if [ ! -d ${build_dir} ]; then
    mkdir ${build_dir}
    cd ${build_dir}
    echo "Mkdir ${build_dir} and cd."
else
    rm -rf ${build_dir} 
    mkdir ${build_dir}
    cd ${build_dir}
    # make clean
    echo "cd ${build_dir}"
fi

#------------------------------------------------------------------------------
#cmake.
sudo cmake \
-D CMAKE_BUILD_TYPE=${build_type} \
-D CMAKE_INSTALL_PREFIX=${install_prefix} \
-D OPENCV_EXTRA_MODULES_PATH=${opencv_contrib_dir}/modules \
-D PYTHON_EXCUTABLE=${python_interpreter} \
-D OPENCV_GENERATE_PKGCONFIG=ON \
-D INSTALL_PYTHON_EXAMPLES=OFF \
-D INSTALL_C_EXAMPLES=OFF \
-D BUILD_opencv_xfeatures2d=OFF \
-D BUILD_EXAMPLES=ON \
-D BUILD_TIFF=ON \
-D WITH_TIFF=ON \
-D WITH_OPENMP=ON \
-D WITH_FFMPEG=ON \
-D ENABLE_FAST_MATH=ON \
${cmake_file_path}

if [ $? -eq 0 ] ; then
  echo "CMake configuration make successful."
else
  echo "CMake issues " >&2
  echo "Please check the configuration being used"
  exit 1
fi
sleep 2
#------------------------------------------------------------------------------
#make opencv.
echo "NUM_CPU: ${num_of_cpu}"
time make -j${num_of_cpu}

if [ $? -eq 0 ] ; then
  echo "OpenCV make successful"

  sudo make install
  if [ $? -eq 0 ] ; then
    echo "OpenCV installed in: ${install_prefix}"
  else
    echo "There was an issue with the final installation"
    exit 1
  fi

else
  echo "Make did not build " >&2
fi