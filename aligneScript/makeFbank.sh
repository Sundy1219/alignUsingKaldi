#!/bin/bash
#Copyright 2016  Tsinghua University (Author: Dong Wang, Xuewei Zhang).  Apache 2.0.

#run from ../..
#DNN training, both xent and MPE


. ./cmd.sh ## You'll want to change cmd.sh to something that will work on your system.
           ## This relates to the queue.

. ./path.sh ## Source the tools/utils (import the queue.pl)

stage=0
nj=4

. utils/parse_options.sh || exit 1;

gmmdir=$1
alidir=$2
alidir_cv=$3

#generate fbanks
if [ $stage -le 0 ]; then
  rm -rf data/fbank && mkdir -p data/fbank &&  cp -R data/train data/fbank || exit 1;
  for x in train; do
    echo  -e "\nproducing fbank for data\n"
    steps/make_fbank.sh --nj $nj --cmd "$train_cmd" data/fbank/$x exp/make_fbank/$x fbank/$x || exit 1
    steps/compute_cmvn_stats.sh data/fbank/$x exp/fbank_cmvn/$x fbank/$x || exit 1
  done
fi
