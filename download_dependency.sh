# Package Manager
PM=apt    #Linux
# PM=brew   #MacOS

# sudo add-apt-repository "deb http://security.ubuntu.com/ubuntu xenial-security main"

# sudo apt update

sudo ${PM} install \
build-essential \
libgtk2.0-dev \
pkg-config \
libavcodec-dev \
libavformat-dev \
libswscale-dev \
libjpeg-dev \
libtiff5-dev \
ffmpeg \
libtbbmalloc2 \
libpng-dev \
libdc1394-dev
