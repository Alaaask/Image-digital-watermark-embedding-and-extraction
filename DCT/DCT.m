% GB 2312

clc;
clear;

%------------------------嵌入算法------------------------

% 读取Lenna载体图像
% 将其矩阵转换为double型
Lenna = imread('D:\Lenna.bmp');
subplot(1,2,1),imshow(Lenna),title('原始图像');
Lenna = double(Lenna)/255;

% 提取红色分量
% 取这一层作为隐藏载体
LennaR = Lenna(:,:,1);

% 按位读取秘密信息并保存在矩阵M中
% 得到矩阵M的大小——秘密信息长度sizeM
infile = fopen('D:\hidefile.txt','r');
[M,sizeM] = fread(infile,'ubit1');
fclose(infile);


% 对图像分块做DCT变换
LennaRDCT = blkproc(LennaR,[8 8],'dct2');

% 得到的系数矩阵的大小sizeL
[sizexL, sizeyL] = size(LennaRDCT);
sizeL = sizexL * sizeyL;

% 进行嵌入
% 成功隐藏的秘密信息长度cnt
% 有效块系数之差的绝对值,最低阈值x,最高阈值y
cnt = 0;
x = 0.3;
y = 2;
j = 1;
i = 1;

% a < b 表示0, a > b 表示1
% a = b 的情况排除了 abs(a - b) >= x
while i <= sizeM && j < sizeL
    a = LennaRDCT(j);
    b = LennaRDCT(j + 1);
    if abs(a - b) >= x && abs(a - b) <= y
        if M(i,1) == 0        
            if  a > b 
                LennaRDCT(j) = b;
                LennaRDCT(j + 1) = a;
            end
        else
            if  a < b
                LennaRDCT(j) = b;
                LennaRDCT(j + 1) = a;
            end
        end
        cnt = cnt + 1;
        i = i + 1;
    end
    j = j + 2;
end

% 显示图像
NewLennaR = blkproc(LennaRDCT,[8 8],'idct2');
NewLenna = Lenna;
NewLenna(:,:,1) = NewLennaR;
subplot(1,2,2),imshow(NewLenna),title('嵌入水印之后图像');

% 写入文件
imwrite(NewLenna,'D:\NewLenna.bmp','bmp');

%------------------------提取算法------------------------

% 水印提取到watermark.txt文件中

% 已知水印的长度sizeM = 688, 阈值大小x,y的值
sizeM = 688;
x = 0.3;
y = 2;

% 准备写入watermark.txt文件
outfile = fopen('D:\watermark.txt','w+');

% 读取嵌入水印之后的图像
NL = imread('D:\NewLenna.bmp');
NL = double(NL)/255;

% 取红色分量
NLR = NL(:,:,1);

% 进行DCT变换
NLRDCT = blkproc(NLR, [8 8],'dct2');

% DCT系数矩阵的大小
[sizex, sizey] = size(NLRDCT);
size = sizex * sizey;

m = 1;
n = 1;

% 提取水印
% c < d 表示0, c > d 表示1
while m <= sizeM && n < size
    c = NLRDCT(n);
    d = NLRDCT(n + 1);
    if abs(c - d) >= x && abs(c - d) <= y
        if  c < d
            fwrite(outfile,0,'ubit1');
        else 
            fwrite(outfile,1,'ubit1');
        end
        m = m + 1;
    end
    n = n + 2;
end

fclose(outfile);

%------------------------说   明------------------------
% 感觉当交换了矩阵中部分元素后，会导致矩阵dct变换又逆变换后的值(本该一样的部分)与原来的值不一样，一个交换影响一片？
% 这样基于元素大小判断就会出错...
% 代码应该是没有bug的，但是无论如何调整x,y的值，结果都不是很满意，应该是算法跟dct有不适应的地方...QAQ