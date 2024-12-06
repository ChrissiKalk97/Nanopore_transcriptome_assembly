#!/bin/bash

# ----- This script is the master script to run the    transcriptome assembly starting from a clean Ensembl ref  ----- #
# ----- short reads and long reads are required for the transcriptome assembly which will be done per condition  ----- #
# ----- the assemblies per condition will be merged and renamed to obtain a final assembled transcriptome with   ----- #
# ----- short and long read support                                                                              ----- #


StarGenomeIndex=/scratch/fuchs/agschulz/kalk/star/clean_Ensembl_reference
GenomeFasta=/scratch/fuchs/agschulz/kalk/star/Homo_sapiens.GRCh38.dna.primary_assembly_110.fa
FilteredEnsemblGtf=/scratch/fuchs/agschulz/kalk/star/filtered_Ensembl_reference/Ensembl_equality_and_TSL_filtered.gtf
GenomeGtfFull=/scratch/fuchs/agschulz/kalk/star/Homo_sapiens.GRCh38.110.chr.gtf
ReadLengthMinOne=74
ShortReadDir=/scratch/fuchs/agschulz/kalk/sra_results/files/trimmed
LongReadDir=/scratch/fuchs/agschulz/kalk/nanopore_long_reads
OutDirStar=/scratch/fuchs/agschulz/kalk/star/clean_Ensembl_ref_aligned/final
RemoveShortReadName=_trimmomatic_crop_75_slow_2_threads.fastq

BowtieIndexDir=/scratch/fuchs/agschulz/kalk/clean_Ensembl_reference/EASTR/bowtie_index/index_110_EASTR_final
EastrOutDir=/scratch/fuchs/agschulz/kalk/clean_Ensembl_reference/EASTR/final
ListBam=/home/fuchs/agschulz/kalk/scripts/nanopore_ana/clean_Ensembl_reference/eastr/Ens_clean_bamlist.txt
#List of all the bam files that are supposed to be cleaned by EASTR

MinimapOutDir=/scratch/fuchs/agschulz/kalk/clean_Ensembl_reference/minimap2_with_juncs/final

StrigntieOutDir=/scratch/fuchs/agschulz/kalk/clean_Ensembl_reference/stringtie_lone_assemblies/final

SalmonRefDir=/scratch/fuchs/agschulz/kalk/clean_Ensembl_reference/salmon/assemblies_for_quantification/stringtie_merge_dKD_control/final
SalmonOutDir=/scratch/fuchs/agschulz/kalk/clean_Ensembl_reference/salmon/control_dKD/final


#load required packages
. ~/spack/share/spack/setup-env.sh
spack load star@2.7.10b

bash Star_steps.sh $StarGenomeIndex $GenomeFasta $FilteredEnsemblGtf $ReadLengthMinOne $ShortReadDir $OutDirStar $RemoveShortReadName


bash EASTR_steps.sh $GenomeFasta $BowtieIndexDir $EastrOutDir $ListBam


bash Minimap_with_juncs.sh $GenomeFasta $EastrOutDir/Karousis_filtered_junctions $LongReadDir $MinimapOutDir

# # bash Stringtie gedoens and rename gedoens

bash Stringtie_steps.sh $FilteredEnsemblGtf $StrigntieOutDir $EastrOutDir/Karousis_data_filtered $MinimapOutDir $GenomeGtfFull

# bash salmon 
bash Salmon_steps.sh "$StrigntieOutDir"/control_dKD/dKD_merged_control_final.gtf $GenomeFasta $SalmonRefDir $SalmonOutDir $ShortReadDir
