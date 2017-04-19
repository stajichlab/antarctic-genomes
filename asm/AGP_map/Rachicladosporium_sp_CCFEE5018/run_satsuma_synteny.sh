#!/usr/bin/bash
#SBATCH --nodes 1 --ntasks 17 --mem-per-cpu 2gb   --time 18:00:00
module load satsuma2
export SATSUMA2_PATH=/opt/linux/centos/7.x/x86_64/pkgs/satsuma2/2016-11-22/bin
SatsumaSynteny2 -slaves 8 -threads 2  -t Rachicladosporium_antarcticum_CCFEE_5527.sort.fasta -q Rachicladosporium_sp_CCFEE_5018.sort.fasta -o Rachicladosporium_antarcticum_CCFEE_5527.SatusumaSynteny2
