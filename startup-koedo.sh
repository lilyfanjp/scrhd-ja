#!/bin/sh

sudo i2cdetect -y 1 0x74 0x74 | grep "74" -
if [ "$?" -eq 0 ]; then
	  sudo python koedo.py
fi
