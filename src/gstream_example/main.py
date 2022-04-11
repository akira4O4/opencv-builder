import os
import cv2
from loguru import logger

from decoder import VideoDecode


def main():

    vd = VideoDecode(url='xxx.mp4')
    cap = vd.get_cap('File')
    
    # vd = VideoDecode(url='rtsp://')
    # cap = vd.get_cap('RTSP_H264')

    # vd.opencv_info()
    stream_info = vd.stream_info(cap)
    logger.info(f'[Decode Test]::stream info: {stream_info}')

    for frame in vd.dec(cap):
        cv2.imshow('frame', frame)
        cv2.waitKey(stream_info['fps'])


if __name__ == '__main__':
    main()
