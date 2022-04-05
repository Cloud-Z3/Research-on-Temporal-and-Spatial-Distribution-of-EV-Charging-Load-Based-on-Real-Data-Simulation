import pandas as pd
import numpy as np
from copy import deepcopy
from matplotlib import pyplot as plt
import time
import os
import math
import scipy.io as scio
import seaborn as sns
import matplotlib
#matplotlib.rcParams['font.sans-serif']=['Times New Roman'] #显示中文标签
matplotlib.rcParams['font.sans-serif']=['KaiTi'] #显示中文标签

df_km=pd.read_csv('.\\3 cluster_result\\k_means_merge(after POI).csv',encoding='gbk')#中心点
df_fast=pd.read_csv('.\\7 AnotherData\\Change\\changefastnew1.csv',header=None)
df_slow=pd.read_csv('.\\7 AnotherData\\Change\\changeslownew1.csv',header=None)
district=['居民居住区','公司企业区','公共服务区','其他']
'''
df=pd.DataFrame({
    '工作日':df_fri['fri'],
    '周末':df_sat['sat']
})'''
place=1
fig, ax = plt.subplots(2, 2, sharex='col', sharey='row')
for d in district:
    print(d)
    fri=[]
    sat=[]

    fripre=[sum([df_fast[j][i]*50+df_slow[j][i]*7.5 for i in df_fast.index if df_km['分区'][i]==d]) for j in range(1440,8640)]
    #fripre = [sum([df_fast[j][i] + df_slow[j][i] for i in df_fast.index if df_km['分区'][i] == d]) for j in range(1440, 8640)]
    fri=[sum([fripre[j*1440+i] for j in range(5)])/5 for i in range(1440)]
    sat=[sum([df_fast[j][i]*50+df_slow[j][i]*7.5 for i in df_fast.index if df_km['分区'][i]==d]) for j in range(8640,10080)]

    matrix=[]
    for i in range(1440):
        matrix.append([i / 60, fri[i], '工作日'])
        matrix.append([i / 60, sat[i], '周  末'])

    df=pd.DataFrame(matrix,columns=['时间(h)','负荷(kW)',''])

    font={#'family':'serif',
         'style':'italic',
        'weight':'normal',
          'color':'black',
          'size':16
    }
    plt.subplot(2,2,place)
    sns.lineplot(data=df,x='时间(h)',y='负荷(kW)',hue='')
    #fig,ax=plt.subplots(111)
    plt.plot([6,6],[0,max(max(fri),max(sat))],'g--')
    #plt.legend(labels=["工作日","周末"])
    plt.axis([0,24,0,max(max(fri),max(sat))])
    plt.xticks([0,4,6,8,12,16,20,24],font={'family':'Times New Roman'})
    plt.yticks(list(range(0,int(max(max(fri),max(sat))),int(max(max(fri),max(sat)))//5)),font={'family':'Times New Roman'})
    plt.xlabel('时间(h)',fontdict={'size':13})
    plt.ylabel('负荷(kW))',fontdict={'size':13})
    #plt.xticks(fontsize=10)
    plt.text(3, max(max(fri),max(sat))/2, s="慢\n充\n模\n式",fontdict=font)
    plt.text(15, max(max(fri),max(sat))/2, s="快\n充\n模\n式",fontdict=font)
    #ax.ticklabel_format(useOffset=False)
    place+=1
plt.savefig('.\\6 DataAna\\LoadWithTime(4 functional areas).png',dpi=500)
plt.show()
#plt.show()
#print(changelow)
'''
for i in df_km.index:
    center.append([df_km.iloc[i]['经度'],df_km.iloc[i]['纬度']])
print(center)
for i in df_points.index:
    mindist=100
    index=0
    point=[df_points.iloc[i]['起点经度'],df_points.iloc[i]['起点纬度']]
    for j in range(k):
        if dist(center[j],point)<mindist:
            mindist=dist(center[j],point)
            index=j
    plt.scatter(point[0],point[1], s=6, color=colorst[index])

for i in range(k):
    plt.scatter(center[i][0],center[i][1], marker='*', s=20, color='black')
'''
#plt.savefig(".\\3 cluster_result\\k_means_merge_new"+".png")
#plt.show()
'''
time_end=time.time()

print('程序运行时间为', time_end - time_start)'''