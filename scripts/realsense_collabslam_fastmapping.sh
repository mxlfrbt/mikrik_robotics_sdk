#!/bin/bash

cd "$( dirname "$0" )" || exit

INSTALL_DIR=/opt/ros/humble/share/collab-slam
RVIZ_FIL=$INSTALL_DIR/tutorial-fastmapping/collab_slam_fm.rviz

# Include pre-script which handles clean shutdown of all background processes
. $INSTALL_DIR/pre.sh

# Launch Realsense camera
ros2 launch realsense2_camera rs_launch.py align_depth:=true depth_module.profile:='848,480,15' rgb_camera.profile:='848,480,15' enable_infra1:=true align_depth.enable:=true  enable_sync:=true initial_reset:=true &
ros2 run depthimage_to_laserscan depthimage_to_laserscan_node --remap  depth:=/camera/depth/image_rect_raw --remap depth_camera_info:=/camera/depth/camera_info --remap  --ros-args -p scan_time:=0.033 -p range_min:=0.1 -p range_max:=2.5 -p output_frame:=camera_depth_frame &
pid1=$!

# Launch Realsense camera TF
ros2 run tf2_ros static_transform_publisher 0.065 0 0.053 0 0 0 base_link camera_link --ros-args -p use_sim_time:=false  &
pid2=$!

# Launch the collab slam tracker
ros2 launch univloc_tracker collab_slam_nav.launch.py use_odom:=true server_rviz:=false enable_fast_mapping:=true zmin:=0.25 zmax:=0.55 voxel_size:=0.05 traj_store_path:=/tmp/ octree_store_path:=/tmp/octree_map.bin save_map_path:=/tmp/pointcloud_map.msg save_traj_folder:=/tmp/ image_frame:=camera_color_optical_frame &
pid3=$!

# Launch rviz
rviz2 -d $RVIZ_FIL &
pid4=$!

echo $pid1 $pid2 $pid3 $pid4 > /tmp/cslam.pid

# Wait for CTRL-C to be pressed
tail -f /dev/null