#!/bin/bash

source /opt/ros/humble/setup.bash
ros2 launch nav2_bringup mikrik_cslam_nav2_launch.py use_sim_time:=false params_file:=<your-system-path-here>/mikrik_robotics_sdk/nav2_configs/mikrik_robot_nav2.param.yaml 
