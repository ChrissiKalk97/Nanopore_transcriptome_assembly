#!/bin/bash

# -----  ----- #

NewAssembly=$1
GenomeFasta=$2
SalmonRefDir=$3
SalmonOutDir=$4
ShortReadDir=$5

if [ ! -d $SalmonRefDir ]; then
    mkdir $SalmonRefDir
fi

if [ ! -d $SalmonOutDir ]; then
    mkdir $SalmonOutDir
fi


bash Salmon_scripts/get_transcriptome_fasta.sh\
 $NewAssembly\
 $GenomeFasta \
 "$SalmonOutDir"/rescue_custom_rules_filter_rescued_transcriptome.fa\
 "$SalmonOutDir"/rescue_custom_rules_filter_rescued_gentrome.fa


# stupidly Sqanti introduces dup transcripts after the rescue
awk '/^>/ { if (seq_id) print seq_id, length(seq); seq_id=$1; seq=""; next } { seq=seq $0 } END { print seq_id, length(seq) }' "$SalmonOutDir"/rescue_custom_rules_filter_rescued_gentrome.fa > "$SalmonOutDir"/transcript_lengths.txt
sort -k1,1 -k2,2nr "$SalmonOutDir"/transcript_lengths.txt | sort -u -k1,1 > "$SalmonOutDir"/longest_transcripts.txt
awk 'NR==FNR { longest[substr($1, 2)]; next } 
/^>/ { print_it = (substr($1, 2) in longest) } 
print_it' "$SalmonOutDir"/longest_transcripts.txt  "$SalmonOutDir"/rescue_custom_rules_filter_rescued_gentrome.fa > "$SalmonOutDir"/rescue_custom_rules_filter_rescued_gentrome_deduplicated.fa

bash Salmon_scripts/create_index.sh\
  "$SalmonOutDir"/rescue_custom_rules_filter_rescued_gentrome_deduplicated.fa\
 "$SalmonRefDir"



bash Salmon_scripts/salmon_dKD_control.sh\
 $SalmonRefDir\
 $ShortReadDir\
 $SalmonOutDir

















