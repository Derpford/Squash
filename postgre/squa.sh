#!/bin/bash
# Squa.sh -- A script to smack bits of data at a database.

# Start by getting some opts.
# Here's the defaults:
db=$(whoami)		# The default database.
com="psql" 		# The default program to run remotely. Any pipeable database command will do.
host=$(hostname)	# The default hostname and username is the current one.
user=$(whoami)		# This way, you can't read the script to find my database server.
table=blog		# The default table.
			# Identity isn't set; that way, I can check to see if you're actually using one. Of course, it's recommended that you do.

# And here's where we check the user's options.
while getopts i:h:f:c:d: opt; do
	case $opt in
		i) # Use this identity file.
			identity=$OPTARG
			;;
		h) # Username and Hostname.
			host=$OPTARG
			;;
		f) # File.
			inputfile=$OPTARG
			;;
		c) # The command to use.
			com=$OPTARG
			;;
		d) # The database to use.
			db=$OPTARG
			;;
	esac
done

# Now we make a function to handle actually connecting, because this'll happen all over the place.
function connectToDB {
	if [ ! $identity ]; then
		ssh $host "echo \"$sqlcom\" | $com $db" # This sticks our SQL command into ssh, where it hits $com.
	else
		ssh -i $identity $host "echo \"$sqlcom\" | $com $db" # Same, with a key file.
	fi
}

# The end result should be something along the lines of "insert into $table(title, text) values($filename, $(cat $filename)"
sqlcom="insert into $table (title, text) values ('$inputfile', '$(cat $inputfile)');"
# Next up, the important bits.
connectToDB
