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

if [ ! -d "$SalmonOutDir"/index_files ]; then
    mkdir "$SalmonOutDir"/index_files
fi


bash Salmon_scripts/get_transcriptome_fasta.sh\
 $NewAssembly\
 $GenomeFasta \
 "$SalmonOutDir"/index_files/dKD_merged_control_renamed_MSTRG_transcriptome.fa\
 "$SalmonOutDir"/index_files/dKD_merged_control_renamed_MSTRG_gentrome.fa


bash Salmon_scripts/create_index.sh\
  "$SalmonOutDir"/index_files/dKD_merged_control_renamed_MSTRG_gentrome.fa\
 "$SalmonRefDir"



bash Salmon_scripts/salmon_dKD_control.sh\
 $SalmonRefDir\
 $ShortReadDir\
 $SalmonOutDir

















