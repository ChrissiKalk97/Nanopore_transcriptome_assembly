#!/bin/bash
. ~/spack/share/spack/setup-env.sh
spack load kallisto
kallisto index -i /scratch/fuchs/agschulz/kalk/Squanti3/kallisto/dKD_control/final/index/kallisto_dKD_control\
 /scratch/fuchs/agschulz/kalk/clean_Ensembl_reference/salmon/control_dKD/final/index_files/dKD_merged_control_renamed_MSTRG_transcriptome.fa
