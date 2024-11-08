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



#control
#decided to only take the second replicate as the first one had such a low mapping rate
/home/fuchs/agschulz/kalk/tools/stringtie-2.2.3.Linux_x86_64/stringtie\
 -o $StrigntieOutDir/control_clean_Ens_assembly.gtf\
 --mix -G $GenomeGTF \
 $EastrFilteredBams/control_short_merged_clean_Ens_EASTR_filtered.bam\
 $MinimapOutDir/Scr_2.bam


#UPF1 assembly
/home/fuchs/agschulz/kalk/tools/stringtie-2.2.3.Linux_x86_64/stringtie\
 -o $StrigntieOutDir/UPF1_clean_Ens_assembly.gtf\
 --mix -G $GenomeGTF \
 $EastrFilteredBams/UPF1_short_merged_clean_Ens_EASTR_filtered.bam\
 $MinimapOutDir/UPF1_KD.bam

#dKD assembly
/home/fuchs/agschulz/kalk/tools/stringtie-2.2.3.Linux_x86_64/stringtie\
 -o $StrigntieOutDir/dKD_clean_Ens_assembly.gtf\
 --mix -G $GenomeGTF \
 $EastrFilteredBams/dKD_short_merged_clean_Ens_EASTR_filtered.bam\
 $MinimapOutDir/dKD.bam

# # replace the gene and tids by the original gene and tids instead of what Stringtie invented
# python replace_gene_id_and_tid_by_ref_name.py $StrigntieOutDir/control_clean_Ens_assembly.gtf $StrigntieOutDir/control_clean_Ens_assembly_gene_and_tid_names.gtf
# python replace_gene_id_and_tid_by_ref_name.py $StrigntieOutDir/dKD_clean_Ens_assembly.gtf $StrigntieOutDir/dKD_clean_Ens_assembly_gene_and_tid_names.gtf
# python replace_gene_id_and_tid_by_ref_name.py $StrigntieOutDir/UPF1_clean_Ens_assembly.gtf $StrigntieOutDir/UPF1_clean_Ens_assembly_gene_and_tid_names.gtf

# #gffcompare to check how many transcripts are assembeled in the new assemblies compared to reference
# gffcompare -L -o control_dKD_gffcomp_with_ref\
#  -r /Users/christina/Documents/NMD_prediction/clean_Ensembl_reference/clean_ref_tsl_and_gffcompare/Ensembl_equality_and_TSL_filtered.gtf\
#   control_clean_Ens_assembly_gene_and_tid_names.gtf\
#    dKD_clean_Ens_assembly_gene_and_tid_names.gtf 

# python get_mapping_STRG_ids_by_tracking_gffcomapre.py\
#  control_dKD/control_dKD_gffcomp_with_ref.tracking\
#   control_clean_Ens_assembly_gene_and_tid_names.gtf\
#    control_clean_Ens_assembly_gene_and_tid_names_for_diff_analysis_with_dKD.gtf\
#     dKD_clean_Ens_assembly_gene_and_tid_names.gtf\
#      dKD_clean_Ens_assembly_gene_and_tid_names_for_diff_analysis_with_control.gtf



# python gtf_to_bed_XLOC.py\
#  control_dKD/control_clean_Ens_assembly_gene_and_tid_names_for_diff_analysis_with_dKD.gtf\
#   control_dKD/control_clean_Ens_assembly_gene_and_tid_names_for_diff_analysis_with_dKD.bed XLOC
# python gtf_to_bed_XLOC.py control_dKD/dKD_clean_Ens_assembly_gene_and_tid_names_for_diff_analysis_with_control.gtf\
#  control_dKD/dKD_clean_Ens_assembly_gene_and_tid_names_for_diff_analysis_with_control.bed XLOC



# python intersect_gffcompare_ids.py Ensembl_110_genes.bed\
#  control_dKD/dKD_clean_Ens_assembly_gene_and_tid_names_for_diff_analysis_with_control.bed\
#   control_dKD/dKD_clean_Ens_assembly_gene_and_tid_names_for_diff_analysis_with_control.gtf\
#    control_dKD/dKD_renamed.gtf
# python intersect_gffcompare_ids.py Ensembl_110_genes.bed  control_dKD/dKD_clean_Ens_assembly_gene_and_tid_names_for_diff_analysis_with_control.bed control_dKD/dKD_clean_Ens_assembly_gene_and_tid_names_for_diff_analysis_with_control.gtf control_dKD/dKD_renamed.gtf
# python intersect_gffcompare_ids.py Ensembl_110_genes.bed  control_dKD/dKD_clean_Ens_assembly_gene_and_tid_names_for_diff_analysis_with_control.bed control_dKD/dKD_clean_Ens_assembly_gene_and_tid_names_for_diff_analysis_with_control.gtf control_dKD/dKD_renamed.gtf


# # Filter out those entries where the strand is not defined
# awk -F " " '$7!="."' dKD_renamed.gtf > dKD_renamed_filtered.gtf

 #decided to only take the second replicate as the first one had such a low mapping rate
# /home/fuchs/agschulz/kalk/tools/stringtie-2.2.3.Linux_x86_64/stringtie\
#  --merge \
#  -o /scratch/fuchs/agschulz/kalk/clean_Ensembl_reference/salmon/assemblies_for_quantification/stringtie_merge_dKD_control/dKD_merged_control.gtf\
#  /scratch/fuchs/agschulz/kalk/clean_Ensembl_reference/salmon/assemblies_for_quantification/dKD_vs_control/control_dKD_renamed_filtered.gtf\
#   /scratch/fuchs/agschulz/kalk/clean_Ensembl_reference/salmon/assemblies_for_quantification/dKD_vs_control/dKD_renamed_filtered.gtf


/home/fuchs/agschulz/kalk/tools/stringtie-2.2.3.Linux_x86_64/stringtie\
  --merge \
  -o $StrigntieOutDir/stringtie_merge_dKD_control/dKD_merged_control.gtf\
  $StrigntieOutDir/dKD_clean_Ens_assembly.gtf\
   $StrigntieOutDir/control_clean_Ens_assembly.gtf


# activate conda env required for the python scripts
PATH="/home/fuchs/agschulz/kalk/miniforge3/bin:$PATH"
source /home/fuchs/agschulz/kalk/.bashrc
source /home/fuchs/agschulz/kalk/miniforge3/etc/profile.d/conda.sh
eval "$(conda shell.bash hook)"
source activate myenvname

python replace_gene_id_and_tid_by_ref_name_MSTRG.py $StrigntieOutDir/stringtie_merge_dKD_control/dKD_merged_control.gtf\
 $StrigntieOutDir/stringtie_merge_dKD_control/dKD_merged_control_gid_tid_reference.gtf

awk -F " " '$7!="."' $StrigntieOutDir/stringtie_merge_dKD_control/dKD_merged_control_gid_tid_reference.gtf\
 > $StrigntieOutDir/stringtie_merge_dKD_control/dKD_merged_control_gid_tid_reference_filtered.gtf


python gtf_to_bed.py\
 $GenomeGtfFull\
  $StrigntieOutDir/stringtie_merge_dKD_control/Homo_sapiens.GRCh38.110.chr.bed reference

python gtf_to_bed.py $StrigntieOutDir/stringtie_merge_dKD_control/dKD_merged_control_gid_tid_reference_filtered.gtf\
 $StrigntieOutDir/stringtie_merge_dKD_control/dKD_merged_control_gid_tid_reference_filtered.bed MSTRG 


python intersect_MSTRG.py\
 $StrigntieOutDir/stringtie_merge_dKD_control/dKD_merged_control_gid_tid_reference_filtered.bed\
 $StrigntieOutDir/stringtie_merge_dKD_control/Homo_sapiens.GRCh38.110.chr.bed\
  $StrigntieOutDir/stringtie_merge_dKD_control/dKD_merged_control_gid_tid_reference_filtered.gtf\
   $StrigntieOutDir/stringtie_merge_dKD_control/dKD_merged_control_final_renamed.gtf