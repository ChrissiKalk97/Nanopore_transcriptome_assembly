#!/bin/bash
. ~/spack/share/spack/setup-env.sh
spack load gffread
transcriptome_assembly=/scratch/fuchs/agschulz/kalk/clean_Ensembl_reference/clean_Ens_reference/Ensembl_equality_and_TSL_filtered.gtf
genome_fasta=/scratch/fuchs/agschulz/kalk/star/Homo_sapiens.GRCh38.dna.primary_assembly_110.fa
transcriptome_fasta=/scratch/fuchs/agschulz/kalk/clean_Ensembl_reference/clean_Ens_reference/Ensembl_equality_and_TSL_filtered.fa

gffread $transcriptome_assembly -g $genome_fasta -w $transcriptome_fasta

spack load kallisto
kallisto index -i /scratch/fuchs/agschulz/kalk/Squanti3/kallisto/dKD_control/final/index/reference\
 $transcriptome_fasta
