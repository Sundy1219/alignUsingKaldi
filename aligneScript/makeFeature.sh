#!/bin/bash

. ./cmd.sh ## You'll want to change cmd.sh to something that will work on your system.
           ## This relates to the queue.
. ./path.sh

H=`pwd`  #exp home
n=4      #parallel jobs

#corpus and trans directory
thchs=$1

local/data_prepare.sh $H $thchs || exit 1;

#produce MFCC features 
rm -rf data/mfcc && mkdir -p data/mfcc &&  cp -R data/train data/mfcc || exit 1;
for x in train; do
   #make  mfcc 
   steps/make_mfcc.sh --nj $n --cmd "$train_cmd" data/mfcc/$x exp/make_mfcc/$x mfcc/$x || exit 1;
   #compute cmvn
   steps/compute_cmvn_stats.sh data/mfcc/$x exp/mfcc_cmvn/$x mfcc/$x || exit 1;
done
#train dnn model
local/nnet/makeFbank.sh --stage 0 --nj $n  exp/tri4b exp/tri4b_ali exp/tri4b_ali_cv || exit 1;  
