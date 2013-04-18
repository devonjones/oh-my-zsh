# "rep" command.  Like:
#
#  rep 10 echo foo
function rep() { 
	local count="$1" i;
	shift;
	for i in $(seq 1 "$count");
	do
		eval "$@";
	done
}

# Subfunction needed by `rep'.
function seq() { 
	local lower upper output;
	lower=$1 upper=$2;
	while [ $lower -le $upper ];
	do
		output="$output $lower";
		lower=$[ $lower + 1 ];
	done;
	echo $output
}


