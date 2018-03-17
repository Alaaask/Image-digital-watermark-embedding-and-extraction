% GB 2312

clc;
clear;

%------------------------Ƕ���㷨------------------------

% ��ȡLenna����ͼ��
% �������ת��Ϊdouble��
Lenna = imread('D:\Lenna.bmp');
subplot(1,2,1),imshow(Lenna),title('ԭʼͼ��');
Lenna = double(Lenna)/255;

% ��ȡ��ɫ����
% ȡ��һ����Ϊ��������
LennaR = Lenna(:,:,1);

% ��λ��ȡ������Ϣ�������ھ���M��
% �õ�����M�Ĵ�С����������Ϣ����sizeM
infile = fopen('D:\hidefile.txt','r');
[M,sizeM] = fread(infile,'ubit1');
fclose(infile);


% ��ͼ��ֿ���DCT�任
LennaRDCT = blkproc(LennaR,[8 8],'dct2');

% �õ���ϵ������Ĵ�СsizeL
[sizexL, sizeyL] = size(LennaRDCT);
sizeL = sizexL * sizeyL;

% ����Ƕ��
% �ɹ����ص�������Ϣ����cnt
% ��Ч��ϵ��֮��ľ���ֵ,�����ֵx,�����ֵy
cnt = 0;
x = 0.3;
y = 2;
j = 1;
i = 1;

% a < b ��ʾ0, a > b ��ʾ1
% a = b ������ų��� abs(a - b) >= x
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

% ��ʾͼ��
NewLennaR = blkproc(LennaRDCT,[8 8],'idct2');
NewLenna = Lenna;
NewLenna(:,:,1) = NewLennaR;
subplot(1,2,2),imshow(NewLenna),title('Ƕ��ˮӡ֮��ͼ��');

% д���ļ�
imwrite(NewLenna,'D:\NewLenna.bmp','bmp');

%------------------------��ȡ�㷨------------------------

% ˮӡ��ȡ��watermark.txt�ļ���

% ��֪ˮӡ�ĳ���sizeM = 688, ��ֵ��Сx,y��ֵ
sizeM = 688;
x = 0.3;
y = 2;

% ׼��д��watermark.txt�ļ�
outfile = fopen('D:\watermark.txt','w+');

% ��ȡǶ��ˮӡ֮���ͼ��
NL = imread('D:\NewLenna.bmp');
NL = double(NL)/255;

% ȡ��ɫ����
NLR = NL(:,:,1);

% ����DCT�任
NLRDCT = blkproc(NLR, [8 8],'dct2');

% DCTϵ������Ĵ�С
[sizex, sizey] = size(NLRDCT);
size = sizex * sizey;

m = 1;
n = 1;

% ��ȡˮӡ
% c < d ��ʾ0, c > d ��ʾ1
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

%------------------------˵   ��------------------------
% �о��������˾����в���Ԫ�غ󣬻ᵼ�¾���dct�任����任���ֵ(����һ���Ĳ���)��ԭ����ֵ��һ����һ������Ӱ��һƬ��
% ��������Ԫ�ش�С�жϾͻ����...
% ����Ӧ����û��bug�ģ�����������ε���x,y��ֵ����������Ǻ����⣬Ӧ�����㷨��dct�в���Ӧ�ĵط�...QAQ