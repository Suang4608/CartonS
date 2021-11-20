#!/bin/bash
#
#blast_mapping_gb
#ver=1.4
#Dependency
##blast load by module
#Input set
##place input files in 00_input
#Parameter setting
##-q: refrence.fa
##-d: database.fa
##-s: sort_size(num)
##-r: refrence.gb
##-o: output.gb

#set blast version
blast_ver=2.12.0+

#get argumant

while getopts :q:d:s:r:o: option
do
	case "${option}"
		in
		q) query=${OPTARG};;
		d) database=${OPTARG};;
		s) sort_size=${OPTARG};;
		r) refrence=${OPTARG};;
		o) out=${OPTARG};;
		?) echo "No -${OPTARG} argumant foumd.";;
	esac
done

echo "kspkspCrycat"

#run blast

module purge
module load blast/$blast_ver

mkdir 01_blast
mkdir 01_blast/blastdb

BLAST_RESULTS=blast_"$query"_"$database".txt

makeblastdb \
	-in 00_input/$database \
	-input_type fasta \
	-dbtype nucl \
	-parse_seqids \
	-out 01_blast/blastdb/$database \
	-logfile 01_blast/blastdb/"$database"_blastdb.log

blastn \
	-query 00_input/$query \
	-db 01_blast/blastdb/$database \
	-out 01_blast/$BLAST_RESULTS \
	-outfmt "7 qseqid sseqid qlen slen sstrand pident length mismatch gapopen qstart qend sstart send"

echo "kspkspHEHE"

#sort blast results

BLAST_RESULTS_SORT=blast_"$query"_"$database"_sort"$sort_size".txt
if [ -n "$sort_size" ]; then
	BS=6
	BT=$(cat -b 01_blast/$BLAST_RESULTS |grep "# BLAST processed" |cut -c "1-6")
	BE=$(expr ${BT} - 1)
	SR=$(for i in $(seq ${BS} ${BE})
		do
	
		line=$(sed -n ${i}p 01_blast/$BLAST_RESULTS)
		size=$(echo "$line" |cut -f 7)
		if [ $size -gt $sort_size ]; then
	
		echo $line
	
		fi
		done
		)
	ST="# BLAST processed"
	echo -e "$SR\n$ST" > 01_blast/$BLAST_RESULTS_SORT
else
	
	cat 01_blast/$BLAST_RESULTS > 01_blast/$BLAST_RESULTS_SORT

fi

echo $BT
#echo "sorting function still under development"

#run mapping

BS=1
BT=$(cat -b 01_blast/$BLAST_RESULTS_SORT |grep "# BLAST processed" |cut -c "1-6")
BE=$(expr ${BT} - 1)
ORI=$(cat -b 00_input/$refrence |grep "ORIGIN"|cut -c "1-6")
END=$(cat -b 00_input/$refrence |grep "//"|grep -v ":"| cut -c "1-6")
	HE=$(expr ${ORI} - 1)
	TS=$(expr ${ORI} + 0)
	TE=$(expr ${END} + 0)
	
head=$(sed -n 1,${HE}p 00_input/$refrence)
alli=$(for i in $(seq ${BS} ${BE})
	do
	line=$(sed -n ${i}p 01_blast/$BLAST_RESULTS_SORT)
	Label=$(echo "$line"| cut -d " " -f 2)
	pS=$(echo "$line"| cut -d " " -f 10)
	pE=$(echo "$line"| cut -d " " -f 11)
	note=$(echo "$line"| cut -d " " -f 4,5,6,7,8,9,12,13)
		echo -e "\t misc_feature\t $pS..$pE\n\t\t\t\t\t /label=$Label\n\t\t\t\t\t /note=$note"
	done)
tail=$(sed -n ${TS},${TE}p 00_input/$refrence)
echo -e "$head\n$alli\n$tail" > $out

echo $BT
echo "query = $query"
echo "database = $database"
echo "sort_size = $sort_size"
echo "refrence = $refrence"
echo "out = $out"
echo "POG"

