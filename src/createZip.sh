#!/bin/bash

# This is bash script is meant to be used when creating new .zip files to be submitted to ssc
# To use this script, open GitBash (or other command line or terminal window) and navigate to where this file is located
# Then run the file using this command: sh createZip.#!/bin/sh

# Currently this script needs 7zip (7z) to be installed,


echo Which is filename of the .zip file you are createing? Write on exactly this format: ietoolkit_v6_1.zip
read filename

7z a $filename ./ado_files/* ./help_files/*
