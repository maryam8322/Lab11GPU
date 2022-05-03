#!/bin/bash -l
# (c) mkbane, university of liverpool [Jan2021]
## example script to check/load CUDA module and run given EXECUTABLE on batch GPU

#SBATCH -t 1             # default: max 1 minute wallclock for batch job
#SBATCH -p gpuc,gpu      # default partitions (queues)
#SBATCH --gres=gpu:1     # default: request 1 of the 4 available GPUs
## NB do not use '--exclusive' 

# (1) check if CUDA loaded, if not then load



if [[ `module list 2>&1 | grep -c cuda` -eq "0" ]]; then
  module load libs/nvidia-cuda/10.1.168/bin
fi

echo '--- modules complete ---';echo


SRC=$1
EXE=${SRC:0:-3}.exe
rm -f ${EXE}

# (2) compil code
nvcc $SRC -o $EXE
echo compiling $SRC to $EXE

#increase stacksize
ulimit -s unlimited
    
# (3) run executable $1

if ! test -x ./$EXE ; then 
	echo usage\: $0 EXE
	echo \(non\-executable EXE\)
    else
	./$EXE
fi

echo '--- execution complete ---';echo

