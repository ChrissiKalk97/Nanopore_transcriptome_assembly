#!/bin/bash

# ----- This script is the master script to run thethe transcriptome assembly starting from a clean Ensembl ref  ----- #
# ----- short reads and long reads are required for the transcriptome assembly which will be done per condition  ----- #
# ----- the assemblies per condition will be merged and renamed to obtain a final assembled transcriptome with   ----- #
# ----- short and long read support                                                                              ----- #


StarGenomeIndex=/scratch/fuchs/agschulz/kalk/star/clean_Ensembl_reference
GenomeFasta=/scratch/fuchs/agschulz/kalk/star/Homo_sapiens.GRCh38.dna.primary_assembly_110.fa
FilteredEnsemblGtf=/scratch/fuchs/agschulz/kalk/star/filtered_Ensembl_reference/Ensembl_equality_and_TSL_filtered.gtf
GenomeGtfFull=/scratch/fuchs/agschulz/kalk/star/Homo_sapiens.GRCh38.110.chr.gtf
ReadLengthMinOne=74
ShortReadDir=/scratch/fuchs/agschulz/kalk/sra_results/files/trimmed
OutDirStar=/scratch/fuchs/agschulz/kalk/star/clean_Ensembl_ref_aligned/final
RemoveShortReadName=_trimmomatic_crop_75_slow_2_threads.fastq

BowtieIndexDir=/scratch/fuchs/agschulz/kalk/clean_Ensembl_reference/EASTR/bowtie_index/index_110_EASTR/final
EastrOutDir=/scratch/fuchs/agschulz/kalk/clean_Ensembl_reference/EASTR/final
ListBam=/home/fuchs/agschulz/kalk/scripts/nanopore_ana/clean_Ensembl_reference/eastr/Ens_clean_bamlist.txt
#List of all the bam files that are supposed to be cleaned by EASTR

MinimapOutDir=/scratch/fuchs/agschulz/kalk/clean_Ensembl_reference/minimap2_with_juncs

StrigntieOutDir=/scratch/fuchs/agschulz/kalk/clean_Ensembl_reference/stringtie_lone_assemblies


#load required packages
. ~/spack/share/spack/setup-env.sh
spack load star@2.7.10b

bash Star_steps.sh $StarGenomeIndex $GenomeFasta $FilteredEnsemblGtf $ReadLengthMinOne $ShortReadDir $OutDirStar $RemoveShortReadName

#bash eastr.sh

bash EASTR_steps.sh $GenomeFasta $BowtieIndexDir $EastrOutDir $ListBam

#bash minimap_with_juncs.sh

bash Minimap_with_juncs.sh $GenomeFasta $EastrOutDir/Karousis_filtered_junctions $MinimapOutDir

#bash Stringtie gedoens and rename gedoens

bash Stringtie_steps.sh $FilteredEnsemblGtf $StrigntieOutDir $EastrOutDir/Karousis_data_filtered $MinimapOutDir $GenomeGtfFull

#bash salmon 
