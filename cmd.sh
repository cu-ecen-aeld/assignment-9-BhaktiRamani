#!/bin/bash


# This file is for Personal use
# Bhakti Ramani

git add .
git commit -m "$m"
git push origin main

echo "Git Push Completed"

if [ "$1" = "run" ]; then
	cd /home/bakri/Work/1_CU_Boulder/AESD/actions-runner
	./run.sh
fi



