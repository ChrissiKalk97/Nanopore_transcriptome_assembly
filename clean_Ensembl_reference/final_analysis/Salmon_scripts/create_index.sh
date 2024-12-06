#!/bin/bash
. ~/spack/share/spack/setup-env.sh
spack load salmon

gentrome=$1
outdir=$2


salmon index -t $1 -d /scratch/fuchs/agschulz/kalk/decoys.txt\
 -i $2
