#!/bin/bash

stop_children() {
    kill -2 $pid
}

trap stop_children SIGINT

ADBSCAN_PARAM_FILE=/opt/ros/humble/share/tutorial-follow-me/params/followme_adbscan_RS_params.yaml
RVIZ_FIL=/opt/ros/humble/share/tutorial-follow-me/config/adbscan_RS_config.rviz

ros2 launch realsense2_camera rs_launch.py pointcloud.enable:=true &
pid="$pid $!"

ros2 run adbscan_ros2_follow_me adbscan_sub --params-file $ADBSCAN_PARAM_FILE --ros-args --remap /cmd_vel:=/mobile_mikrik/cmd_vel &
pid="$pid $!"

ros2 run rviz2 rviz2 -d $RVIZ_FIL &
pid="$pid $!"

echo "$pid" > /tmp/tutorial-follow-me.pid

# Wait for CTRL-C to be pressed
wait $pid