#!/bin/bash

# ----- This script is the master script to run thethe transcriptome assembly starting from a clean Ensembl ref  ----- #
# ----- short reads and long reads are required for the transcriptome assembly which will be done per condition  ----- #
# ----- the assemblies per condition will be merged and renamed to obtain a final assembled transcriptome with   ----- #
# ----- short and long read support                                                                              ----- #


GenomeFasta=$1
EastrJunctionDir=$2
LongReadDir=$3
MinimapOutDir=$4



#load required packages
. ~/spack/share/spack/setup-env.sh
spack load minimap2
spack load samtools

if [ ! -d $MinimapOutDir ]; then
    mkdir $MinimapOutDir
fi


minimap2\
 -ax splice $GenomeFasta\
 --junc-bed  $EastrJunctionDir/clean_Ens_filtered_junctions_control_sorted.bed\
 $LongReadDir/Scr_2.fastq\
 > $MinimapOutDir/Scr_2.sam

minimap2\
 -ax splice $GenomeFasta\
 --junc-bed  $EastrJunctionDir/clean_Ens_filtered_junctions_UPF1_KD_sorted.bed\
 $LongReadDir/UPF1_KD.fastq\
 > $MinimapOutDir/UPF1_KD.sam

minimap2\
 -ax splice $GenomeFasta\
 --junc-bed  $EastrJunctionDir/clean_Ens_filtered_junctions_dKD_sorted.bed\
 $LongReadDir/SMG6_SMG7_dKD.fastq\
 > $MinimapOutDir/minimap2_with_juncs/dKD.sam


for file in $MinimapOutDir/*.sam
do
samtools flagstat ${file} >\
 $MinimapOutDir/$(basename $file .sam)_flagstat.out
done

for file in $MinimapOutDir/*.sam
do
samtools sort -o \
$MinimapOutDir/$(basename $file .sam).bam\
 ${file}
 samtools index $MinimapOutDir/$(basename $file .sam).bam
done




