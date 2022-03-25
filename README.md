此项目提供了3个编译脚本用于在linux，jetson，macos M1上进行opencv的编译和安装.

在jetson和linux的OpenCV编译中提供了CUDA和GStream支持，其中MacOS M1不支持CUDA和GStream。

编译opencv完成后生产相对于的python—opencv模块。

同时提供了c++和python的gstream程序和opencv测试程序。



在所有的编译脚本中提供了四个配置参数：

1. INSTALL_DIR：库文件安装路径

2. PYTHON3_EXECUTABLE：python解释权路径

3. OPENCV_SOURCE_DIR：opencv源码路径

4. OPENCV_CONTRIB_SOURCE_DIR：opencv contirb库源码路径



## 使用

运行对应平台的install.sh脚本，脚本将会自动进行opencv的cmake make和install安装。



## 配置路径

在.bashrc或者.zshrc中写入以下内容完成路径配置，其中的参数在install.sh中有写出：

- export PKG_CONFIG_PATH=$OPENCV_PKG_PATH:\$PKG_CONFIG_PATH

- export LD_LIBRARY_PATH=$INSTALL_DIR/lib:\$LD_LIBRARY_PATH

- export PATH=$OPENCV_CMAKE_PATH:\$PATH



执行一下命令完成python-opencv模块的配置

```bash
sudo cp 库安装目录/lib/python3.8/site-packages/cv2/python-3.8/cv.python-38-darwin.so ~/miniforge3/envs/xxx/lib/python3.8/site-packages/cv2.so
```

## 

## 测试

### OpenCV测试

正常的测试结果为打开本地摄像头。



### Gstream测试

正常的测试结果为拉取网络rtsp流进行解码并使用opencv进行播放。

在MacOS M1中没有Gstream框架，所有在并不能运行对于的c++或者python测试程序，在linux和jetson中可以正常运行测试。

执行以下命令完成c++程序测试：

```bash
mkdir build
cd build
cmake ..
make
./main
```

执行以下命令完成python程序测试：

```bash
python main.py
```
