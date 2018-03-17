function result = jpgandalpha(test, msg)

test = 'D:\Lenna.jpg';
msg = 'D:\hidefile.txt';

quality = 10:10:100;
alpha = 0.1:0.1:1;
result = zeros([max(size(alpha)) max(size(quality))]);
resultr = 0;
resultc = 0;
figure(1);
cnt = 0;
for a = alpha
    resultr = resultr + 1;
    [count, message, hideresult] = hidedctadv(test, 'temp.jpg', msg, 2003, a);
    cnt = cnt + 1;
    subplot(2,5,cnt),imshow(hideresult),title(['alpha = ',num2str(a)]);
    resultc = 0;
    different = 0;
    for q = quality
        resultc = resultc + 1;
        imwrite(hideresult, 'temp.jpg', 'jpg', 'quality', q);
        msgextract = extractdctadv('temp.jpg', 'temp.txt', 2003, count);
        for i = 1:count
            if message(i, 1) ~= msgextract(i, 1);
                different = different + 1;
            end
        end
        result(resultr, resultc) = different/count;
        different = 0;
    end

disp(['完成了第', int2str(resultr), '个(共10个)α的鲁棒性测试，请等待...']);
end

figure(2);
for i = 1:10
    plot(quality, result(i,:), 'Color', [i/10 0 0]);
    hold on;
end
xlabel('jpeg压缩率');
ylabel('提取的信息与原始信息不同的百分比例');
title('控制阈值α在JPEG条件下对隐藏鲁棒性的影响');
text(60,0.5,'颜色越红alpha值越大');
