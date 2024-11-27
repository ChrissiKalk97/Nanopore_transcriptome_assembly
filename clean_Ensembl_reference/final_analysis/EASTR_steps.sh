#!/bin/bash

# ----- This script is the master script to run thethe transcriptome assembly starting from a clean Ensembl ref  ----- #
# ----- short reads and long reads are required for the transcriptome assembly which will be done per condition  ----- #
# ----- the assemblies per condition will be merged and renamed to obtain a final assembled transcriptome with   ----- #
# ----- short and long read support                                                                              ----- #


GenomeFasta=$1
BowtieIndexDir=$2
EastrOutDir=$3
ListBam=$4


#load required packages
export PATH=$PATH:/home/fuchs/agschulz/kalk/tools/EASTR/utils
. ~/spack/share/spack/setup-env.sh
spack load samtools
spack load bowtie2
spack load bedtools2


# check Bowtie index dir exists
if [ ! -d $BowtieIndexDir ]; then
    mkdir $BowtieIndexDir
fi

# build bowtie index
# bowtie2-build $GenomeFasta $BowtieIndexDir



# check EASTR output dirs exist
if [ ! -d $EastrOutDir ]; then
    mkdir $EastrOutDir
fi

if [ ! -d "$EastrOutDir"/Karousis_data_filtered ]; then
    mkdir "$EastrOutDir"/Karousis_data_filtered
fi

if [ ! -d "$EastrOutDir"/Karousis_original_junctions ]; then
    mkdir "$EastrOutDir"/Karousis_original_junctions
fi

if [ ! -d "$EastrOutDir"/Karousis_removed_junctions ]; then
    mkdir "$EastrOutDir"/Karousis_removed_junctions
fi

if [ ! -d "$EastrOutDir"/Karousis_filtered_junctions ]; then
    mkdir "$EastrOutDir"/Karousis_filtered_junctions
fi


eastr\
    --bam $ListBam\
    --reference $GenomeFasta\
    --bowtie2_index $BowtieIndexDir\
    --out_filtered_bam "$EastrOutDir"/Karousis_data_filtered/\
    --out_original_junctions "$EastrOutDir"/Karousis_original_junctions\
    --out_removed_junctions "$EastrOutDir"/Karousis_removed_junctions\
    --verbose\
    -p 12


# bedtools substract
for JunctionBed in "$EastrOutDir"/Karousis_original_junctions/*.bed
do
bedtools subtract\
   -a $JunctionBed\
   -b "$EastrOutDir"/Karousis_removed_junctions/$(basename $JunctionBed _original_junctions.bed)_removed_junctions.bed\
   > "$EastrOutDir"/Karousis_filtered_junctions/$(basename $JunctionBed _original_junctions.bed)_filtered_junctions.bed
done

# sort bedfiles
for JunctionBed in "$EastrOutDir"/Karousis_filtered_junctions/*.bed
do
sort -k 1,1 -k2,2n\
 $JunctionBed\
 > "$EastrOutDir"/Karousis_filtered_junctions/$(basename $JunctionBed .bed)_sorted.bed
done

# merge the bedfiles
cat "$EastrOutDir"/Karousis_filtered_junctions/clean_Ens_SRR4081222_filtered_junctions_sorted.bed\
 "$EastrOutDir"/Karousis_filtered_junctions/clean_Ens_SRR4081223_filtered_junctions_sorted.bed\
 "$EastrOutDir"/Karousis_filtered_junctions/clean_Ens_SRR4081224_filtered_junctions_sorted.bed\
 "$EastrOutDir"/Karousis_filtered_junctions/clean_Ens_SRR4081237_filtered_junctions_sorted.bed\
 "$EastrOutDir"/Karousis_filtered_junctions/clean_Ens_SRR4081238_filtered_junctions_sorted.bed\
 "$EastrOutDir"/Karousis_filtered_junctions/clean_Ens_SRR4081239_filtered_junctions_sorted.bed\
  > "$EastrOutDir"/Karousis_filtered_junctions/clean_Ens_filtered_junctions_control_sorted.bed

cat "$EastrOutDir"/Karousis_filtered_junctions/clean_Ens_SRR4081225_filtered_junctions_sorted.bed\
 "$EastrOutDir"/Karousis_filtered_junctions/clean_Ens_SRR4081227_filtered_junctions_sorted.bed\
 "$EastrOutDir"/Karousis_filtered_junctions/clean_Ens_SRR4081227_filtered_junctions_sorted.bed\
  > "$EastrOutDir"/Karousis_filtered_junctions/clean_Ens_filtered_junctions_UPF1KD_sorted.bed


cat "$EastrOutDir"/Karousis_filtered_junctions/clean_Ens_SRR4081246_filtered_junctions_sorted.bed\
 "$EastrOutDir"/Karousis_filtered_junctions/clean_Ens_SRR4081247_filtered_junctions_sorted.bed\
 "$EastrOutDir"/Karousis_filtered_junctions/clean_Ens_SRR4081248_filtered_junctions_sorted.bed\
  > "$EastrOutDir"/Karousis_filtered_junctions/clean_Ens_filtered_junctions_dKD_sorted.bed



# Merge the filtered bams per condition to use with Stringtie mix later
path="$EastrOutDir"/Karousis_data_filtered
samtools merge\
 -o $path/control_short_merged_clean_Ens_EASTR_filtered.bam\
 $path/clean_Ens_SRR4081222_EASTR_filtered.bam $path/clean_Ens_SRR4081223_EASTR_filtered.bam $path/clean_Ens_SRR4081224_EASTR_filtered.bam\
 $path/clean_Ens_SRR4081238_EASTR_filtered.bam $path/clean_Ens_SRR4081237_EASTR_filtered.bam $path/clean_Ens_SRR4081239_EASTR_filtered.bam
samtools index $path/control_short_merged_clean_Ens_EASTR_filtered.bam


samtools merge\
 -o $path/UPF1_short_merged_clean_Ens_EASTR_filtered.bam\
 $path/clean_Ens_SRR4081226_EASTR_filtered.bam $path/clean_Ens_SRR4081227_EASTR_filtered.bam $path/clean_Ens_SRR4081228_EASTR_filtered.bam
samtools index $path/UPF1_short_merged_clean_Ens_EASTR_filtered.bam


samtools merge\
 -o $path/dKD_short_merged_clean_Ens_EASTR_filtered.bam\
 $path/clean_Ens_SRR4081246_EASTR_filtered.bam $path/clean_Ens_SRR4081247_EASTR_filtered.bam $path/clean_Ens_SRR4081248_EASTR_filtered.bam
samtools index $path/dKD_short_merged_clean_Ens_EASTR_filtered.bam
#no need to resort the files as the input bam files are already sorted