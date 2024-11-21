#!/bin/bash

source /opt/ros/humble/setup.bash
source ~/ros-humble-ros1-bridge/install/local_setup.bash
export ROS_IP=172.72.2.1
export ROS_MASTER_URI=http://rosrobot:11311 
ros2 run ros1_bridge dynamic_bridge --bridge-all-1to2-topics
