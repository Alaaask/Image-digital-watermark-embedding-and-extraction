% ��ȡ������ͼ������λ��Ϊˮӡ���ֱ�Ƕ������ͼ��ĸ���λƽ��
% ��ʾ˳��Ϊ��Ƕ���nλƽ��Ľ����n = 7,6,5,4,3,2,1,0
% ����Ϊ��Ƕ��LSB�Ĳ��ɸ�֪����ã���������ѹ���Ȳ�������Ƕ��LSB��³���Բ���

% ��ȡ�ļ�
cover = imread('Lenna.bmp');
msg = imread('woman.bmp');

% ��ʾ����ͼ�������ͼ��
subplot(9,2,1),imshow(cover),title('����ͼ��');
subplot(9,2,2),imshow(msg),title('����ͼ��');

% ��������
i = 1;
j = 3;
bias1 = [127 191 223 239 247 251 253 254];
bias2 = [128 64 32 16 8 4 2 1];

while i <= 8
% ���д�������Ϊ��7λƽ�浽��0λƽ�棬i=1��i=8
cover1 = bitand(cover,bias1(i));
msg1 = bitand(msg,128);
msg1 = bitshift(msg1,1-i);
covernew = bitor(cover1,msg1);

% д������֮���ͼ��ѭ����ΪǶ��LSB֮���ͼ��
imwrite(covernew,'max.bmp','bmp');

% ��ʾ����֮���ͼ��
subplot(9,2,j),imshow(covernew),title('����֮���ͼ��');

% ��ȡˮӡ����ʾ
msgnew = bitand(covernew,bias2(i));
msgnew = bitshift(msgnew,i-1);
subplot(9,2,j + 1),imshow(msgnew),title('��ȡ��ˮӡ');

i = i + 1;
j = j + 2;
end