#!/bin/bash
. ~/spack/share/spack/setup-env.sh
spack load salmon


index=$1
ShortReadDir=$2
SalmonOutDir=$3

for rep in {46..48}
do
salmon quant -i $index\
 -l A -r "$ShortReadDir"/SRR40812${rep}_trimmomatic_crop_75_slow_2_threads.fastq \
 --validateMappings\
 -o $SalmonOutDir/bootstraps/SRR40812${rep}_bootstrap\
 --seqBias --gcBias --posBias --reduceGCMemory --numBootstraps 100
done


for rep in {37..39}
do
salmon quant -i $index\
 -l A -r "$ShortReadDir"/SRR40812${rep}_trimmomatic_crop_75_slow_2_threads.fastq \
 --validateMappings\
 -o $SalmonOutDir/bootstraps/SRR40812${rep}_bootstrap\
 --seqBias --gcBias --posBias --reduceGCMemory --numBootstraps 100
done
