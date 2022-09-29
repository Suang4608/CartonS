#!/bin/bash
#
#convert fasta to 2 line format

I=in.fa
O=out.fa

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
		printf $0 >> O
		}
	}
	END{printf "\n" >> O}
' $I

