#!/bin/bash
. ~/spack/share/spack/setup-env.sh
spack load gffread

transcriptome_assembly=$1
genome_fasta=$2
transcriptome_fasta=$3
gentrome=$4

#get transcriptome fasta
gffread $transcriptome_assembly -g $genome_fasta -w $transcriptome_fasta


#generate gentrome
cat  $transcriptome_fasta $genome_fasta > $gentrome
