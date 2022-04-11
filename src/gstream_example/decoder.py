import os
import yaml

import cv2
import numpy as np
from loguru import logger

def load_yaml_conf(conf_path: str) -> dict:
    """
    @brief: 加载yaml配置文件
    :param conf_path: xxx/xxx/xxx.yaml
    :return: dict
    """
    assert conf_path.endswith(".yaml") is True, f'file type must be yaml'
    assert os.path.exists(conf_path) is True, f'{conf_path}is error'
    if conf_path.endswith(".yaml"):
        with open(conf_path, 'r', encoding='UTF-8') as f:
            conf = yaml.safe_load(f)
    return conf

class VideoDecode:
    """
         解码类
    """

    def __init__(self, url: str = None, *args, **kwargs):
        """
        Args:
            url: 拉流地址
        """
        _local_path = os.path.dirname(__file__)
        self.gst_cmd = load_yaml_conf(os.path.join(_local_path, 'config.yaml'))['gst_decode']

        self.url = url
        logger.info(f'[VideoDecode]::Input Stream URL: {self.url}.')

    def set_url(self, url):
        self.url = url

    def show_dec_type(self):
        logger.info(f'gst decode support type: {self.gst_cmd.keys()}')

    @staticmethod
    def opencv_info():
        """
        :brief: 展示opencv模块的编译配置信息
        """
        print(cv2.getBuildInformation())

    @staticmethod
    def stream_info(cap):
        """
        :brief: 显示流信息
        :param cap: cv2.VideoCapture()
        :return: 流信息
        """
        width = cap.get(cv2.CAP_PROP_FRAME_WIDTH)
        height = cap.get(cv2.CAP_PROP_FRAME_HEIGHT)
        fps = cap.get(cv2.CAP_PROP_FPS)
        fourcc = cap.get(cv2.CAP_PROP_FOURCC)
        fourcc = "".join([chr((int(fourcc) >> 8 * i) & 0xFF) for i in range(4)])

        format_ = cap.get(cv2.CAP_PROP_FORMAT)

        info = {
            'width': int(width),
            'height': int(height),
            'fps': int(fps),
            'fourcc': fourcc,
            'format': format_
        }
        # cap.release()
        return info

    def dec(self, cap, fs: int = None, resize: tuple = None, *args, **kwargs):
        """
        @brief:software 返回一个迭代器

        @code:project/test/video_dec_ai.py

        Args:
            cap: (cv2.VideoCapture())
            fs: (int) - 拉流采样频率,默认为None时，采用数据原始帧率。eg: 当fs=1时，每隔1s返回一张图片。
            resize: (tuple(int,int)) - 缩放后的宽高 (w,h)

        Returns:
            迭代器每次返回一个numpy.ndarray类型的图片
        """
        success, frame = cap.read()
        if not success:
            logger.error(f'cap read state: {success}')

        stream_info = self.stream_info(cap)
        fps = stream_info['fps']
        fs = fs * fps if fs is not None else 1

        cnt = 0
        while success:
            cnt += 1
            success, frame = cap.read()

            if resize is not None:
                frame = cv2.resize(frame, resize)

            if cnt % fs == 0:
                yield frame if success else None
        cap.release()

    def get_cap(self, dec_type: str = 'Norm'):
        """
        :brief: 获取不同解码方式的cv2.VideoCapture()
        :param dec_type: (str) 输入视频编码方式，当dec_type==Norm的时候，默认使用opencv原生解码
        :return: cv2.VideoCapture()
        """
        logger.info(f'Decode Type for [{dec_type}].')

        if dec_type == 'Norm':
            logger.info(f'Using OpenCV Decode.')
            cap = cv2.VideoCapture(self.url)
        else:
            logger.info(f'Using Gst-OpenCV Decode.')
            _gst_cmd = self.gst_cmd[dec_type].format(self.url)
            logger.info(f'Gst command line: {_gst_cmd}')
            cap = cv2.VideoCapture(_gst_cmd, cv2.CAP_GSTREAMER)
        return cap


if __name__ == '__main__':
    vd = VideoDecode('')
    vd.show_dec_type()
