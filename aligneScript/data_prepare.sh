#!/bin/bash
#Copyright 2016  Tsinghua University (Author: Dong Wang, Xuewei Zhang).  Apache 2.0.

#This script pepares the data directory for thchs30 recipe. 
#It reads the corpus and get wav.scp and transcriptions.

dir=$1
corpus_dir=$2

cd $dir
mkdir -p data/train
  cd $dir/data/train
  rm -rf wav.scp utt2spk spk2utt word.txt phone.txt text
  for nn in `find  $corpus_dir/data/*.wav | sort -u | xargs -i basename {} .wav`; do
      echo $nn $corpus_dir/data/$nn.wav >> wav.scp
      echo $nn $nn >> utt2spk
      echo $nn $nn >> spk2utt
      echo $nn `sed -n 1p $corpus_dir/data/$nn.wav.trn` >> word.txt
      echo $nn `sed -n 3p $corpus_dir/data/$nn.wav.trn` >> phone.txt
  done 
  cp word.txt text
