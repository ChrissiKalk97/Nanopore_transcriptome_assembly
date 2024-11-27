#!/bin/bash

# ----- This script runs the star mapping of the short reads to the genome as well as bam file conversion ----- #
# ----- and sorting                                                                                       ----- #

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

if [ ! -d $StarGenomeIndex ]; then
    mkdir $StarGenomeIndex
fi

if [ ! -d $OutDirStar ]; then
    mkdir $OutDirStar
fi

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
for sam in "$OutDirStar"/*Aligned.out.sam
do
    filename=$(basename $sam Aligned.out.sam)
    samtools sort -o \
    $OutDirStar/${filename}.bam\
    $OutDirStar/${filename}Aligned.out.sam
    samtools index $OutDirStar/${filename}.bam
done

