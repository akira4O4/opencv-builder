# 此项目提供了3个编译脚本用于在linux，jetson，macos M1上进行opencv的编译和安装.  

在jetson和linux的OpenCV编译中提供了CUDA和GStream支持，其中MacOS M1不支持CUDA和GStream。  

编译opencv完成后生产相对于的python—opencv模块。  

同时提供了c++和python的gstream程序和opencv测试程序。  

<br>

在所有的编译脚本中提供了四个配置参数：  

1. INSTALL_DIR：库文件安装路径

2. OPENCV_SOURCE_DIR：opencv源码路径

3. OPENCV_CONTRIB_SOURCE_DIR：opencv contirb库源码路径

---

## 使用
**注意：** 其中对于编译python的部分要注意python环境，脚本中为系统 **base python** 环境，如果想使用自己的环境，可以手动切换环境（```conda activate your_env_name```）然后进行编译，或者修改编译脚本run_cmake()函数中的涉及到python解释器的路径：$(your_env_name/bin/python -c) 
(**个人觉得直接使用conda修改环境比较方便**)

run_cmake()修改部分：
```shell
-D PYTHON_DEFAULT_EXECUTABLE=$(your_env_name/bin/python -c "import sys; print(sys.executable)")   \
-D PYTHON3_EXECUTABLE=$(your_env_name/bin/python -c "import sys; print(sys.executable)")   \
-D PYTHON3_NUMPY_INCLUDE_DIRS=$(your_env_name/bin/python -c "import numpy; print (numpy.get_include())") \
-D PYTHON3_PACKAGES_PATH=$(your_env_name/bin/python -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())") \
```

<br>

反注释掉需要的shell函数，然后执行脚本进行编译，其中的make_opencv函数中的NUM_CPU参数根据自己的电脑CPU核心数进行修改。  

Exampel:
linux/install.sh脚本：  

```shell
# dependency #安装下载依赖
# run_cmake_Norm #原始OpenCV cmake编译
# run_cmake_GStream #带GStream的cmake编译
# run_cmake_CUDA #带CUDA的cmake编译

run_cmake_CUDA_GStream #执行带CUDA GStream的cmake编译
make_opencv #make编译
make_install #make install 安装，安装动态库头文件到INSTALL_DIR路径下
```

<br>

运行对应平台的install.sh脚本，脚本将会自动进行opencv的cmake make和install安装。

---

## 配置路径

在.bashrc或者.zshrc中写入以下内容完成路径配置，其中的参数在install.sh中有写出：

- export PKG_CONFIG_PATH=$OPENCV_PKG_PATH:\$PKG_CONFIG_PATH

- export LD_LIBRARY_PATH=$INSTALL_DIR/lib:\$LD_LIBRARY_PATH

- export PATH=$OPENCV_CMAKE_PATH:\$PATH  

<br>

## python-opencv模块的配置
通常情况下，编译完成后，cv2.xxx.so模块会自动存放在python环境下**your_env_name/lib/python3.x/site-packages/cv2/python-3.x**包中,在python中可以直接```import cv2```使用，但是在ide中会出现波浪号提示找不到函数（**程序可以正常运行**），可以把cv2.xxx.so移动到python环境下**your_env_name/lib/python3.x/site-packages/**,然后改名为cv2.so即可。
```bash
sudo cp env/lib/python3.8/site-packages/cv2/python-3.8/cv.python-38-darwin.so ../../cv2.so
```

如果在环境目录下没有找到cv2.xxx.so包,可以到安装目录下的 **build/lib/python/** 包中找到cv2.xxx.so,然后复制到python环境下改名cv2.so即可使用
```bash
sudo cp build/lib/python3.8/cv.xxx.so your_env_name/lib/python3.8/site-packages/cv2.so
```

---

## 测试

### OpenCV测试

正常的测试结果为打开本地摄像头。  

### Gstream测试

正常的测试结果为拉取网络rtsp流进行解码并使用opencv进行播放。  

在MacOS M1中没有Gstream框架，所有在并不能运行对于的c++或者python测试程序，在linux和jetson中可以正常运行测试。  