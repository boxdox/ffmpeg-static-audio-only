# ffmpeg static build image for audio only pipeline

current static builds of ffmpeg are too bloated, upwards of 150mb for each executable

this repo will hold my customizations, for usage in audio pipelines. 
it only retains flac, alac and aac, and other essential parts, and strips the rest 

and it only publishes the ffmpeg binary
