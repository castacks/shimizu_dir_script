#! /bin/bash
# This script will create the data file system for shimizu test

echo "Give a data folder name:"

read name

root=$PWD/$name

mkdir $root
mkdir $root/bags
mkdir $root/bags/reconstruction
mkdir $root/bags/reconstruction/lidar
mkdir $root/bags/reconstruction/camera
mkdir $root/bags/stereo_calibration
mkdir $root/bags/lidar_camera_calibration
mkdir $root/bags/lidar_camera_calibration/lidar
mkdir $root/bags/lidar_camera_calibration/camera
mkdir $root/clouds
mkdir $root/images
mkdir $root/images/color
mkdir $root/images/color/left
mkdir $root/images/color/right
mkdir $root/images/thermal
mkdir $root/results
mkdir $root/results/calibration
mkdir $root/results/calibration/stereo
mkdir $root/results/calibration/camera_lidar
mkdir $root/results/calibration/camera_thermal
mkdir $root/results/bundle_adjustment
mkdir $root/results/stereo_reconstruction
mkdir $root/results/stereo_reconstruction/configs
mkdir $root/scripts

# create scripts automatically

# record_lidar_cam_calib_bags.sh ------------------------------------------------------------------------------
echo "#! /bin/bash
# This script is for recording lidar-camera calibration bags in $path
# camera bags are in $path/camera, lidar bags are in $path/lidar
# the recording time is preset to be 20 seconds (about 2.5G for a camera bag)

echo \"Give it a INDEX and enter:\" 
read index

path=$root/bags/lidar_camera_calibration
roslaunch shimizu_launch shimizu_sensors_log.launch index:=\$index path:=\$path duration:=20" > $root/scripts/record_lidar_cam_calib_bags.sh
# record_lidar_cam_calib_bags.sh ------------------------------------------------------------------------------


# cp_flir.sh ------------------------------------------------------------------------------
echo "#! /bin/bash
# This script is for copying thermal images from \$src (FLIR camera) to the \$tgt folder 

echo \"Give it a INDEX (thermal/data_[INDEX]/):\" 
read index

tgt=$root/images/thermal/data_\$index
src=/media/theairlab/FLIR

if [ ! -d \"\$src\" ]; then
    echo \"Error: directory \$src doesn't exist, check if the FLIR is mounted.\"
    exit
fi

if [ ! -d \"\$tgt\" ]; then
    mkdir \$tgt
fi

cp \$src/*.jpg \$tgt/

echo \"Copied images:\"
ls -l \$tgt" > $root/scripts/cp_flir.sh
# cp_flir.sh ------------------------------------------------------------------------------

# mv_flir.sh ------------------------------------------------------------------------------
echo "#! /bin/bash
# This script is for copying thermal images from \$src (FLIR camera) to the \$tgt folder 

echo \"Give it a INDEX (thermal/data_[INDEX]/):\" 
read index

tgt=$root/images/thermal/data_\$index
src=/media/theairlab/FLIR

if [ ! -d \"\$src\" ]; then
    echo \"Error: directory \$src doesn't exist, check if the FLIR is mounted.\"
    exit
fi

if [ ! -d \"\$tgt\" ]; then
    mkdir \$tgt
fi

mv \$src/*.jpg \$tgt/

echo \"Moved images:\"
ls -l \$tgt" > $root/scripts/mv_flir.sh

# mv_flir.sh ------------------------------------------------------------------------------


# record_reconstruction_bags.sh ------------------------------------------------------------------------------
echo "#! /bin/bash
# This script is for recording reconstrunction bags
# camera bags are in \$path/camera, lidar bags are in \$path/lidar
# the recording time is preset to be 20 seconds (about 2.5G for a camera bag)

echo \"Give it a INDEX and enter:\" 
read index

path=$root/bags/reconstruction
roslaunch shimizu_launch shimizu_sensors_log.launch index:=\$index path:=\$path duration:=20" > $root/scripts/record_reconstruction_bags.sh
# record_reconstruction_bags.sh ------------------------------------------------------------------------------

# record_stereo_calib_bags.sh ------------------------------------------------------------------------------
echo "#! /bin/bash
# This script is for recording stereo images as a bag file, which will be stored in \$path

path=$root/bags/stereo_calibration
echo \"Recording stereo bag to \$path\"
echo \"Recording time is limited to 5m at maximum\"

roslaunch shimizu_launch shimizu_cam_log.launch path:=\$path duration:=5m" > $root/scripts/record_stereo_calib_bags.sh
# record_stereo_calib_bags.sh ------------------------------------------------------------------------------

chmod +x $root/scripts/*.sh

