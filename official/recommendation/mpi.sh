source /opt/intel/impi/2018.1.163/intel64/bin/mpivars.sh
cd ../..
echo `pwd`
source ./env.sh
cd official/recommendation
rm mpi.log

#export MKLDNN_VERBOSE=2
export KMP_AFFINITY=granularity=fine,verbose,compact,1,0
HOSTLIST="$(hostname)"
SEED=$RANDOM

# 20M
#params=" --no_strategy --train --clean --horovod -synth -md model -hk examplespersecondhook --dataset ml-20m -dd data -te 1 -bs 49152 --layers 256,256,128,64 --num_factors 64 -mts 1000 --inter 1"
params=" --no_strategy \
         --horovod \
         -hk examplespersecondhook \
         -md model \
         -dd data \
         --dataset ml-20m 
         --clean \
         -te 14 \
         -bs 49152 \
         --eval_batch_size 160000 \
         --learning_rate 0.00382059 \
         --beta1 0.783529 \
         --beta2 0.909003 \
         --epsilon 1.45439e-07 \
         --layers 256,256,128,64 --num_factors 64 \
         --hr_threshold 0.635 \
         --ml_perf \
         --seed $SEED \
         --inter 1"

mpirun -n 2 -ppn 1 -genv I_MPI_FABRICS=shm -genv I_MPI_PIN_DOMAIN=sock -genv TF_NUM_INTRAOP_THREADS=27 -genv OMP_NUM_THREADS=28 -genv KMP_BLOCKTIME=1 -genv TF_MKL_OPTIMIZE_PRIMITVE_MEMUSE=false  python3 ncf_main.py $params |& tee -a mpi.log
