#!/bin/bash

# ----- This script is the master script to run thethe transcriptome assembly starting from a clean Ensembl ref  ----- #
# ----- short reads and long reads are required for the transcriptome assembly which will be done per condition  ----- #
# ----- the assemblies per condition will be merged and renamed to obtain a final assembled transcriptome with   ----- #
# ----- short and long read support                                                                              ----- #


StarGenomeIndex=$1
GenomeFasta=$2
FilteredEnsemblGtf=$3
ReadLengthMinOne=$4
ShortReadDir=$5
OutDirStar=$6
RemoveShortReadName=$7


#load required packages
. ~/spack/share/spack/setup-env.sh
spack load star@2.7.10b
spack load samtools

#generate genome index

STAR --runThreadN 16 --runMode genomeGenerate --genomeDir $StarGenomeIndex --genomeFastaFiles $GenomeFasta --sjdbGTFfile $FilteredEnsemblGtf --sjdbOverhang $ReadLengthMinOne

#map fastq files to genome
for fastq in $ShortReadDir/*
do
    STAR --runThreadN 32\
    --genomeDir $StarGenomeIndex\
    --readFilesIn $fastq\
   --outSAMstrandField intronMotif\
    --outFilterMismatchNoverLmax 0.05 \
    --outFilterMatchNminOverLread 0.7 \
    --chimSegmentMin 15 \
    --chimScoreMin 15 \
    --chimScoreSeparation 10 \
    --chimJunctionOverhangMin 15 \
    --twopassMode Basic \
    --chimOutType SeparateSAMold \
    --alignSoftClipAtReferenceEnds No\
    --outSAMattributes NH HI AS nM NM MD jM jI XS \
    --outFileNamePrefix $OutDirStar/clean_Ens_$(basename $fastq $RemoveShortReadName)
done

#sam to bam and index
for sam in $OutDirStar/*
do
    filename=$(basename $sam Aligned.out.sam)
    samtools sort -o \
    $OutDirStar/${filename}.bam\
    $OutDirStar/${filename}Aligned.out.sam
    samtools index $OutDirStar/${filename}.bam
done


samtools merge\
 -o $OutDirStar/control_short_merged_clean_Ens.bam\
 $OutDirStar/clean_Ens_SRR4081222.bam $OutDirStar/clean_Ens_SRR4081223.bam $OutDirStar/clean_Ens_SRR4081224.bam\
 $OutDirStar/clean_Ens_SRR4081238.bam $OutDirStar/clean_Ens_SRR4081237.bam $OutDirStar/clean_Ens_SRR4081239.bam
samtools index $OutDirStar/control_short_merged_clean_Ens.bam


samtools merge\
 -o $OutDirStar/UPF1_short_merged_clean_Ens.bam\
 $OutDirStar/clean_Ens_SRR4081226.bam $OutDirStar/clean_Ens_SRR4081227.bam $OutDirStar/clean_Ens_SRR4081228.bam
samtools index $OutDirStar/UPF1_short_merged_clean_Ens.bam


samtools merge\
 -o $OutDirStar/dKD_short_merged_clean_Ens.bam\
 $OutDirStar/clean_Ens_SRR4081246.bam $OutDirStar/clean_Ens_SRR4081247.bam $OutDirStar/clean_Ens_SRR4081248.bam
samtools index $OutDirStar/dKD_short_merged_clean_Ens.bam
