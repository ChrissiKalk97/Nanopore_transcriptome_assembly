#!/bin/bash -l
PATH="/home/fuchs/agschulz/kalk/miniforge3/bin:$PATH"
source /home/fuchs/agschulz/kalk/.bashrc
source /home/fuchs/agschulz/kalk/miniforge3/etc/profile.d/conda.sh
eval "$(conda shell.bash hook)"
source activate SQANTI3.env
python ~/tools/Squanti/SQANTI3-5.2.2/sqanti3_qc.py \
/scratch/fuchs/agschulz/kalk/clean_Ensembl_reference/stringtie_lone_assemblies/final/control_dKD/dKD_merged_control_final.gtf \
/scratch/fuchs/agschulz/kalk/star/filtered_Ensembl_reference/Ensembl_equality_and_TSL_filtered.gtf \
/scratch/fuchs/agschulz/kalk/Homo_sapiens.GRCh38.dna.primary_assembly_110.fa \
-d /scratch/fuchs/agschulz/kalk/Squanti3/final_assembly_QC_22_11_24 \
--short_reads short_reads_dKD_control.txt \
--expression /scratch/fuchs/agschulz/kalk/Squanti3/kallisto/dKD_control/final/quant/SRR4081237/abundance.tsv,\
/scratch/fuchs/agschulz/kalk/Squanti3/kallisto/dKD_control/final/quant/SRR4081238/abundance.tsv,\
/scratch/fuchs/agschulz/kalk/Squanti3/kallisto/dKD_control/final/quant/SRR4081239/abundance.tsv,\
/scratch/fuchs/agschulz/kalk/Squanti3/kallisto/dKD_control/final/quant/SRR4081246/abundance.tsv,\
/scratch/fuchs/agschulz/kalk/Squanti3/kallisto/dKD_control/final/quant/SRR4081247/abundance.tsv,\
/scratch/fuchs/agschulz/kalk/Squanti3/kallisto/dKD_control/final/quant/SRR4081248/abundance.tsv \
--force_id_ignore \
--polyA_motif_list /home/fuchs/agschulz/kalk/scripts/nanopore_ana/Squanti3/polyAsites/mouse_and_human.polyA_motif.txt
