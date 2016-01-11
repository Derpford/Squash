# Squa.sh
## A script for doing blog things.

A lot of people use blogs nowadays. Some of us use premade tools, others roll our own. Some adventurous fellows use their own server.
This script is for that last group; it's a handy-dandy thing that you can pipe your files into and get those things sent down the tube to your remote SQL database. It'll take care of assembling the command itself; just tell it what file to use, and it'll read the contents into the "text" column, and the filename into "title".

Just to be safe, it'll also read back whatever it just wrote, and compare it to the original file. If it doesn't match, it'll throw an error. Just in case someone wants to man-in-the-middle your blog.
