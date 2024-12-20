#!/bin/bash -l
PATH="/home/fuchs/agschulz/kalk/miniforge3/bin:$PATH"
source /home/fuchs/agschulz/kalk/.bashrc
source /home/fuchs/agschulz/kalk/miniforge3/etc/profile.d/conda.sh
eval "$(conda shell.bash hook)"
source activate SQANTI3.env
python ~/tools/Squanti/SQANTI3-5.2.2/sqanti3_filter.py rules \
/scratch/fuchs/agschulz/kalk/Squanti3/final_assembly_QC_22_11_24/dKD_merged_control_final_classification.txt \
--gtf /scratch/fuchs/agschulz/kalk/Squanti3/final_assembly_QC_22_11_24/dKD_merged_control_final_corrected.gtf  \
--faa /scratch/fuchs/agschulz/kalk/Squanti3/final_assembly_QC_22_11_24/dKD_merged_control_final_corrected.faa \
--isoforms /scratch/fuchs/agschulz/kalk/Squanti3/final_assembly_QC_22_11_24/dKD_merged_control_final_corrected.fasta \
-d /scratch/fuchs/agschulz/kalk/Squanti3/final_assembly_rules_v2_03_12_24 \
--json /home/fuchs/agschulz/kalk/scripts/nanopore_ana/Squanti3/final_nanopore_assembly/filter/custom_filter_v2.json

