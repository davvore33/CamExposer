#!/bin/env bash

echo "Welcom to CamExposer"
echo "Remind to configure your DSLR on gphoto2"


outdev="/dev/video2"

set +e

unset t_std t_err

eval "$( (gphoto2 --stdout --capture-movie | ffmpeg -i - -vcodec rawvideo -pix_fmt yuv420p -threads 0 -f v4l2 $outdev) \
        2> >(readarray -t t_err; typeset -p t_err) \
         > >(readarray -t t_std; typeset -p t_std) )"


for line in "${t_err[@]}"; do
	if [[ "$line" == *"No camera found"* ]]; then
		echo "Please configure/plug your camera"
	fi
done
