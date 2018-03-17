# -*- coding: utf-8 -*-
"""
Created on Sat Dec 30 21:56:00 2017

@author: yu
"""

import sys
import wave
from PIL import Image
import matplotlib.pyplot as plt
import numpy as np
import random

def read_wave_data(file_path):
    #open a wave file, and return a Wave_read object
    f = wave.open(file_path,"rb")
    
    #read the wave's format infomation,and return a tuple
    params = f.getparams()
    #get the info
    nchannels, sampwidth, framerate, nframes = params[:4]
    
    #Reads and returns nframes of audio, as a string of bytes.
    str_data = f.readframes(nframes)
    
    #close the stream
    f.close()
    
    #turn the wave's data to array
    #因为这里我们要对每个byte的LSB进行操作，所以量化单位为8bit
    wave_data = np.fromstring(str_data, dtype = np.uint8)
    
    #calculate the time bar
    time = np.arange(0, nframes) * (1.0/framerate)
    
    return wave_data, time


def read_bmp_data(file_path):
    
    #200*200
    bmp_data = np.array(Image.open(file_path))

    bmp_data.shape = -1, 1
    
    return bmp_data


def embedding_watermark(wave_data, bmp_data):
    
    sequence = random.sample(range(0, len(bmp_data)), len(bmp_data))
    
    new_wave_data = np.zeros(len(wave_data), dtype=np.uint8) # 为什么直接 = wave_data会变成引用？
    j = 0
    
    for i in sequence:
        if bmp_data[i]:
            new_wave_data[j] = wave_data[j] | 0b00000001
        else:
            new_wave_data[j] = wave_data[j] & 0b11111110
        j = j + 1
    
    while j < len(wave_data):
        new_wave_data[j] = wave_data[j]
        j = j + 1
        
    return new_wave_data, sequence

    
def main():
    
    #读取原始音频
    wave_data, time = read_wave_data("E:\python project\djh.wav")
    
    #读取水印图像
    bmp_data = read_bmp_data("E:\python project\\fudan.bmp")
    
    #判断是否能嵌入
    if len(wave_data) < len(bmp_data):
        print("音频文件太小，无法嵌入!")
        sys.exit(0)
    
    #嵌入水印
    #key是嵌入时的随机序列
    new_wave_data, key = embedding_watermark(wave_data, bmp_data)    
    
    #draw the wave
    plt.subplot(211)
    plt.plot(time, wave_data)
    
    plt.subplot(212)
    plt.plot(time, new_wave_data)
    
    plt.xlabel("time (seconds)")
    plt.show()
    
  
if __name__ == "__main__":  
    main()  