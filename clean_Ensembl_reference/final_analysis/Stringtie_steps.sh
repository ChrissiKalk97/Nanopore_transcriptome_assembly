#!/bin/bash

# ----- This script is the master script to run thethe transcriptome assembly starting from a clean Ensembl ref  ----- #
# ----- short reads and long reads are required for the transcriptome assembly which will be done per condition  ----- #
# ----- the assemblies per condition will be merged and renamed to obtain a final assembled transcriptome with   ----- #
# ----- short and long read support                                                                              ----- #


GenomeGTF=$1
StrigntieOutDir=$2
EastrFilteredBams=$3
MinimapOutDir=$4
GenomeGtfFull=$5

# check Bowtie index dir exists
if [ ! -d $StrigntieOutDir/control_dKD ]; then
    mkdir $StrigntieOutDir/control_dKD
fi

if [ ! -d $StrigntieOutDir/control_dKD/gffcompare ]; then
    mkdir $StrigntieOutDir/control_dKD/gffcompare
fi



#control
#decided to only take the second replicate as the first one had such a low mapping rate
# /home/fuchs/agschulz/kalk/tools/stringtie-2.2.3.Linux_x86_64/stringtie\
#  -o $StrigntieOutDir/control_clean_Ens_assembly.gtf\
#  --mix -G $GenomeGTF \
#  $EastrFilteredBams/control_short_merged_clean_Ens_EASTR_filtered.bam\
#  $MinimapOutDir/Scr_2.bam


# #UPF1 assembly
# /home/fuchs/agschulz/kalk/tools/stringtie-2.2.3.Linux_x86_64/stringtie\
#  -o $StrigntieOutDir/UPF1_clean_Ens_assembly.gtf\
#  --mix -G $GenomeGTF \
#  $EastrFilteredBams/UPF1_short_merged_clean_Ens_EASTR_filtered.bam\
#  $MinimapOutDir/UPF1_KD.bam

# #dKD assembly
# /home/fuchs/agschulz/kalk/tools/stringtie-2.2.3.Linux_x86_64/stringtie\
#  -o $StrigntieOutDir/dKD_clean_Ens_assembly.gtf\
#  --mix -G $GenomeGTF \
#  $EastrFilteredBams/dKD_short_merged_clean_Ens_EASTR_filtered.bam\
#  $MinimapOutDir/dKD.bam



/home/fuchs/agschulz/kalk/tools/stringtie-2.2.3.Linux_x86_64/stringtie\
  --merge \
  -o $StrigntieOutDir/control_dKD/dKD_merged_control.gtf\
  $StrigntieOutDir/dKD_clean_Ens_assembly.gtf\
   $StrigntieOutDir/control_clean_Ens_assembly.gtf

# activate conda env required for the python scripts
PATH="/home/fuchs/agschulz/kalk/miniforge3/bin:$PATH"
source /home/fuchs/agschulz/kalk/.bashrc
source /home/fuchs/agschulz/kalk/miniforge3/etc/profile.d/conda.sh
eval "$(conda shell.bash hook)"
source activate myenvname

gffcompare -L -o $StrigntieOutDir/control_dKD/gffcompare\
 -r $GenomeGTF\
  $StrigntieOutDir/control_dKD/dKD_merged_control.gtf


python renaming_scripts/rename_MSTRG_shit.py\
 $StrigntieOutDir/control_dKD/dKD_merged_control.gtf\
  $StrigntieOutDir/control_dKD/gffcompare.dKD_merged_control.gtf.tmap\
    $StrigntieOutDir/control_dKD/dKD_merged_control_renamed.gtf


# Filter out those entries where the strand is not defined
awk -F " " '$7!="."' $StrigntieOutDir/control_dKD/dKD_merged_control_renamed.gtf\
 > $StrigntieOutDir/control_dKD/dKD_merged_control_renamed_filtered.gtf


python renaming_scripts/gtf_to_bed.py\
 $StrigntieOutDir/control_dKD/dKD_merged_control_renamed_filtered.gtf\
 $StrigntieOutDir/control_dKD/dKD_merged_control_renamed_filtered.bed MSTRG 

python renaming_scripts/gtf_to_bed.py\
 $GenomeGtfFull\
  $StrigntieOutDir/control_dKD/Homo_sapiens.GRCh38.110.chr.bed reference

python renaming_scripts/intersect_MSTRG.py\
 $StrigntieOutDir/control_dKD/dKD_merged_control_renamed_filtered.bed\
 $StrigntieOutDir/control_dKD/Homo_sapiens.GRCh38.110.chr.bed\
  $StrigntieOutDir/control_dKD/dKD_merged_control_renamed_filtered.gtf\
   $StrigntieOutDir/control_dKD/dKD_merged_control_final.gtf









# python renaming_scripts/get_mapping_STRG_ids_by_tracking_gffcomapre.py\
#  $StrigntieOutDir/control_dKD/dKD_merged_control_gffcomp_ref.tracking\
#  $StrigntieOutDir/control_dKD/dKD_merged_control.gtf\
#  $StrigntieOutDir/control_dKD/dKD_merged_control_renamed.gtf





