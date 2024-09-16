# OpenCV Builder

## Intro
Here's an OpenCV automated build script that includes dependency download and code compilation/install features. You only need to fill in a few parameters to complete the automation process.

---
## Usage

###  Step.0:
Download opencv and contrib source code
```bash
mkdir opencv_<4.x>
cd opencv_<4.x>
git clone https://github.com/opencv/opencv.git
git clone https://github.com/opencv/opencv_contrib.git
```
Tree:
```bash
opencv_<4.x>/
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
version             =   <4.x>
root                =   <your/path/opencv_4.x>
install_prefix      =   </opt/opencv_4.x/build>
python_interpreter  =   <python_interpreter_path>(maybe you don`t need that)
num_of_cpu          =   <cpu_thread_numbers>
```

```bash
sudo ./build.sh #auto cmake、make and install
```
