#!/bin/bash
#SBATCH --job-name=TranscriptomeAssClean
#SBATCH --partition=fuchs
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24
#SBATCH --time=1-08:40:00
#SBATCH --mail-type=FAIL
#SBATCH --account=agschulz
#SBATCH --mem=120G

NewAssembly=/scratch/fuchs/agschulz/kalk/Squanti3/final_assembly_rescue_v5_24_01_25/rescue_custom_rules_filter_rescued.gtf
GenomeFasta=/scratch/fuchs/agschulz/kalk/star/Homo_sapiens.GRCh38.dna.primary_assembly_110.fa
SalmonRefDir=/scratch/fuchs/agschulz/kalk/clean_Ensembl_reference/salmon/assemblies_for_quantification/stringtie_merge_dKD_control/Sqanti_rescue_v5/index
SalmonOutDir=/scratch/fuchs/agschulz/kalk/clean_Ensembl_reference/salmon/assemblies_for_quantification/stringtie_merge_dKD_control/Sqanti_rescue_v5
ShortReadDir=/scratch/fuchs/agschulz/kalk/sra_results/files/trimmed

srun Salmon_steps_Sqanti_v5.sh $NewAssembly $GenomeFasta $SalmonRefDir $SalmonOutDir $SalmonReadDir
