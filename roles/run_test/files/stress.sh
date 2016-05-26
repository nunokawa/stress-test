#!/bin/sh

killall stress
nohup stress --cpu 16 --vm 12 --vm-bytes 8G &
