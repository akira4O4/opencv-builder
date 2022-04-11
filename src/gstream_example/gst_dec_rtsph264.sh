#!/bin/bash

gst-launch-1.0 rtspsrc latency=20 location="rtsp://admin:admin123@192.168.86.210:554/cam/realmonitor?channel=1&subtype=0" ! rtph264depay ! h264parse ! avdec_h264 ! autovideosink
