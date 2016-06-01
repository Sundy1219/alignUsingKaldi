#!/bin/bash
alidatadir=`pwd`
resample=$1
workdir=$2
cp -r makeFeature.sh $workdir
cp -r makeFbank.sh   $workdir/local/nnet/
cp -r data_prepare.sh $workdir/local/
if [ -f $workdir/data/lang ]
then
    rm -rf $workdir/data/lang
fi
cp -r lang $workdir/data
if [ -f $workdir/exp/tri4b_dnn ]
then
  rm -rf $workdir/exp/tri4b_dnn
fi
cp -r tri4b_dnn $workdir/exp
if [ -f $workdir/exp/tri4b_dnn_ali ]
then
  rm -rf $workdir/exp/tri4_dnn_ali
fi
cp -r tri4b_dnn_ali $workdir/exp
if [ -f $workdir/conf/mfcc.conf ]
then
  rm -rf $workdir/conf/mfcc.conf 
fi
cp mfcc.conf $workdir/conf
if [ -f $workdir/conf/fbank.conf ]
then
  rm -rf $workdir/conf/fbank.conf 
fi
cp fbank.conf $workdir/conf

#修改采样率
echo -e " \n                resample is $resample \n"
cd $alidatadir/data

for x in ./*.wav
do 
  b=${x##*/}
  sox $b -r $resample tmp_"$b"
  rm -rf $b
  mv tmp_"$b" $b
done

cd $workdir
./makeFeature.sh $alidatadir

echo -e "\n                  Starting to align data \n"
sh steps/nnet/align.sh --nj 4 --cmd run.pl data/fbank/train data/lang exp/tri4b_dnn exp/tri4b_dnn_ali
for i in $(seq 4)
do
  gunzip exp/tri4b_dnn_ali/ali."$i".gz
  rm -rf $alidatadir/"dir"/ali."$i".ctm
  ../../../src/bin/ali-to-phones --ctm-output exp/tri4b_dnn_ali/final.mdl ark:exp/tri4b_dnn_ali/ali."$i" -> $alidatadir/data_ali/ali."$i".ctm
  rm -rf exp/tri4b_dnn_ali/ali."$i"
done 
rm -rf makeFeature.sh
rm -rf local/nnet/makeFbank.sh
rm -rf local/data_prepare.sh
echo -e "\nFinshing data alignment,results is in data_ali\n"
