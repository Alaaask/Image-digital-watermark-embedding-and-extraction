% 提取了秘密图像的最高位作为水印，分别嵌入载体图像的各个位平面
% 显示顺序为：嵌入第n位平面的结果，n = 7,6,5,4,3,2,1,0
% 结论为：嵌入LSB的不可感知性最好，但若进行压缩等操作，则嵌入LSB的鲁棒性不佳

% 读取文件
cover = imread('Lenna.bmp');
msg = imread('woman.bmp');

% 显示载体图像和秘密图像
subplot(9,2,1),imshow(cover),title('载体图像');
subplot(9,2,2),imshow(msg),title('秘密图像');

% 参数设置
i = 1;
j = 3;
bias1 = [127 191 223 239 247 251 253 254];
bias2 = [128 64 32 16 8 4 2 1];

while i <= 8
% 进行处理，依次为第7位平面到第0位平面，i=1到i=8
cover1 = bitand(cover,bias1(i));
msg1 = bitand(msg,128);
msg1 = bitshift(msg1,1-i);
covernew = bitor(cover1,msg1);

% 写入隐藏之后的图像（循环完为嵌入LSB之后的图像）
imwrite(covernew,'max.bmp','bmp');

% 显示隐藏之后的图像
subplot(9,2,j),imshow(covernew),title('隐藏之后的图像');

% 提取水印并显示
msgnew = bitand(covernew,bias2(i));
msgnew = bitshift(msgnew,i-1);
subplot(9,2,j + 1),imshow(msgnew),title('提取的水印');

i = i + 1;
j = j + 2;
end