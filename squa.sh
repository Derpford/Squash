#!/bin/bash
# Squa.sh -- A script to smack bits of data at a database.

# Start by getting some opts.
# Here's the defaults:
db=main.db		# The database we're gonna use.
com=isql-vt 		# The default command is isql-vt, since it seems to be nice and pipe-able. Any command-line SQL program that can be piped into should do.
host=$(hostname)	# The default hostname and username is the current one.
user=$(whoami)		# This way, you can't read the script to find my database server.
			# Identity isn't set; that way, I can check to see if you're actually using one. Of course, it's recommended that you do.

# And here's where we check the user's options.
while getopts i:h:u:c:wrd:t:C:k:s: opt; do
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
		w) # We're writing to a spot.
			state=writeTo
			;;
		r) # We're reading from a spot.
			state=readFrom
			;;
		d) # This database.
			db=$OPTARG
			;;
		t) # Where's the table?
			table=$OPTARG
			;;
		C) # And the column?
			column=$OPTARG
			;;
		k) # Will it be updating an existing spot? What column do we use to find it?
			key=$OPTARG
			state=updateTo
			;;
		s) # What are we looking for in the key?
			search=$OPTARG
			;;
	esac
done

# Now we make a function to handle actually connecting, because this'll happen all over the place.
function connectToDB {
	if [ ! $identity ]; then
		echo "$sqlcom" | ssh $user@$host $com # This sticks our SQL command into ssh, where it hits $com.
	else
		echo "$sqlcom" | ssh -i $identity $user@$host $com # Same, with a key file.
	fi
}

# Next up, the important bits.
input="-"
case $state in
	writeTo) # We're writing. Note that this only fills one column in; the rest will end up being empty.
		sqlcom="${db} INSERT INTO ${table} VALUES ${input};"
		connectToDB
		;;
	readFrom) # We're reading from the DB.
		if [[ ! $input ]]; then
			sqlcom="${db} 'SELECT * FROM ${table} WHERE ${column}="${input}"';"
		else
			sqlcom="${db} 'SELECT * FROM ${table};'"
		fi
		connectToDB
		;;
	updateTo) # Updating an existing table.
		sqlcom="${db} 'UPDATE ${table} SET ${column}="${input}" WHERE ${key}="${search}"'"
		connectToDB
		;;
esac


