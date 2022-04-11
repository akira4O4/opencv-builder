#!/bin/bash

gst-launch-1.0 rtspsrc latency=20 location="rtsp://admin:admin123@192.168.86.210:554/cam/realmonitor?channel=1&subtype=0" ! rtph265depay ! h265parse ! avdec_h265 ! autovideosink
