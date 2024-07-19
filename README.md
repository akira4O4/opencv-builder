# OpenCV Builder

***if your need CUDA or GStream support please modify ```build.sh```.***
---
## Usage

###  Step.0:
Download opencv and contrib source code
```bash
mkdir opencv_4.x  
cd opencv_4.x
git clone https://github.com/opencv/opencv.git
git clone https://github.com/opencv/opencv_contrib.git
```
Like this code tree:
```bash
opencv-4.x/
├── opencv
└── opencv_contrib
```


###  Step.1:
Download opencv dependency libs
```bash
git clone https://github.com/akira4O4/opencv-builder
cd opencv-build
sudo ./download_dependency.sh
```

###  Step.2:
Write your parameters
```bash
version             =   <your_opencv_lib_version>
root                =   <your_opencv_code_path>
install_prefix      =   <your_opencv_lib_install_path>
python_interpreter  =   <your_python_interpreter_path>(maybe you don`t need this)
num_of_cpu          =   <your_cpu_thread_numbers>
```

```bash
sudo ./build.sh #auto cmake、make and install
```
