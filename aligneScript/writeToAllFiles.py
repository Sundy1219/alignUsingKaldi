#coding:utf-8
#!/usr/bin/python
#filename:traversefileInPython

import os
import os.path
def write_rbt(cdir):
    os.chdir(cdir)
    for parentdir,dirname,filenames in os.walk(cdir):
        for filename in filenames:
	    position= os.path.splitext(filename)
            if position[1]=='.wav':
	        f=open(position[0] + '.wav.trn','w')
	        f.write('萝卜 头\nluo2 bo5 tou2\nl uo2 b o5 t ou2')
		f.close()
ali_dir=os.getcwd()
data_dir=os.path.join(ali_dir,'data')
write_rbt(data_dir)

