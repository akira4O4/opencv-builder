#!/bin/bash

#gst-launch-1.0 filesrc location="/home/ubuntu/PycharmProjects/ai-system/module/person/data/video.avi" ! \
gst-launch-1.0 filesrc location="video.mp4" ! \
oggdemux name=demux ! queue ! vorbisdec ! autoaudiosink demux. ! \
queue ! theoradec ! videoconvert ! autovideosink




