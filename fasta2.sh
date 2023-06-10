#!/bin/bash
#
#convert fasta to 2 line format

while getopts :i:o: option
do
	case "${option}"
		in
		i) I=${OPTARG};;
		o) O=${OPTARG};;
		?) echo "No -${OPTARG} argumant foumd.";;
	esac
done


awk -v O=$O '
	{
	if ($0~">"&&NR==1)
		{
		print $0 >> O
		}
	else if ( $0 ~ ">" )
		{
		print "\n"$0 >> O
		}
	else
		{
		$0 = toupper($0);	
		printf $0 >> O
		}
	}
	END{printf "\n" >> O}
' $I

