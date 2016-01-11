#!/bin/bash
# Squa.sh -- A script to smack bits of data at a database.

# Start by getting some opts.
# Here's the defaults:
db=main.db		# The default database.
com="sqlite3 -echo" 		# The default program to run remotely. Any pipeable database command will do.
host=$(hostname)	# The default hostname and username is the current one.
user=$(whoami)		# This way, you can't read the script to find my database server.
table="blog"		# The default table.
			# Identity isn't set; that way, I can check to see if you're actually using one. Of course, it's recommended that you do.

# And here's where we check the user's options.
while getopts i:h:u:c:d: opt; do
	case $opt in
		i) # Use this identity file.
			identity=$OPTARG
			;;
		h) # Hostname.
			host=$OPTARG
			;;
		u) # Username.
			user=$OPTARG
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
		ssh $user@$host "$com $db '$sqlcom'" # This sticks our SQL command into ssh, where it hits $com.
	else
		ssh -i $identity $user@$host "$com $db '$sqlcom'" # Same, with a key file.
	fi
}

# The end result should be something along the lines of "insert into $table(title, text) values($filename, $(cat $filename)"
sqlcom="insert into $table (title, text) values (\"$1\", \"$(cat $1)\");"
# Next up, the important bits.
connectToDB
