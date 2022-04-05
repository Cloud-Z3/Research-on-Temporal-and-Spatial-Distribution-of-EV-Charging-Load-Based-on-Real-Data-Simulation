%% �����ʼ��
clc
clear
load('\data.mat')
change = zeros([300 1440*7]);%��¼�������
Co = normrnd(82,2,[1 100000]);%��������ֲ�����ֵ����׼������С��
Ct = min(Co.*normrnd(0.8,0.1,[1 100000]),Co);%��ص�����ʼ�ֲ�
car = zeros([5 100000]);%����״̬�����ʼ��
now_trans = trans(:,:,1);%��ʼ��ת�Ƴ����ĸ���
now_times = times(:,:,1);%��ʼ��ת����Ҫ��ʱ��(��λ���룩
now_distance = distance(:,:,1);%��ʼ��ת����Ҫ��·��(��λ��ǧ�ף�

%% ÿһ���������ݵĳ�ʼ��
car(1,:) = Co;%��1��Ϊ�������
car(2,:) = Ct;%��2��Ϊ��ǰʱ�̵���
pre = 100000.*sum(now_trans,2)./sum(sum(now_trans));%��¼�����ٸ����ĵ�ÿ�����ĵ��ʼʱ���ж��ٳ�
kk = pre(1);
for i = 1:300
    k = floor(kk);
    k_1 = floor(kk-pre(i));
    for j = k_1+1:k
        car(3,j) = i;
    end
    if i < 300
    kk = kk+pre(i+1);
    end
end
car(3,100000) = 300;
%��3��Ϊ��ǰ���ڵأ�ʹ�õ�һҳ��״̬ת�ƾ�����г�ʼ��
for i = 1:100000
    f = sum(now_trans(car(3,i),:));
    if f ~= 0%�ж��Ƿ�������ĵ�û�г���ǰ����һ��Ŀ��
        car(4,i) = randsrc(1,1,[1:300;now_trans(car(3,i),:)./sum(now_trans(car(3,i),:))]);
        car(5,i) = car(5,i)+now_times(car(3,i),car(4,i))/60;%�ۼ�ʱ�䣨����ɱ��ζ���֮���ʱ�䣩
    else
        car(5,i) = car(5,i)+1;%��ԭ��ͣһ����
    end
    car(2,i) = car(2,i) - now_distance(car(3,i),car(4,i))/1000*0.205;%����֮��ʣ���������������Ϊ����
end
%��4��Ϊǰ��Ŀ�ĵأ���5��Ϊ��ɶ���ʱ��ʱ�䣨δ��ʽ��

%% ��ʼѭ������ÿһ�εĶ�������������һ����
t = 361;
while(t < 1440*7)
    %�ж����ڸ�ʹ����һҳ���������ݵ�Ǩ��
    if (mod(t,120) == 0)&&(mod(t,1440) >= 360)
        selmod = ceil(t/1440);
        sel = t/120-selmod*3+1;
        now_trans = trans(:,:,sel);
        now_times = times(:,:,sel);
        now_distance = distance(:,:,sel);
    end
    disp(1)
    %�ж���һ�������Ƿ�ִ����ϣ����ִ����ϾͿ�ʼִ����һ��������ͬʱ���г�������
    if mod(t,1440) >= 360%����֮��ſ�ʼ
        for i = 1:100000
            if t > car(5,i)%�ж��Ƿ񶩵��Ѿ�����ʱЧ
                if car(2,i) < unifrnd(0.15,0.3)*car(1,i) %��紥����0.15��0.3����������ľ��ȷֲ�
                    change(car(4,i),t) = 1+change(car(4,i),t);%��¼��������
                    car(2,i) = abs(unifrnd(0.9,1)*car(1,i));%���г�������˲ʱ
                end
                car(3,i) = car(4,i);%����Ŀ�ĵ�
                f = sum(now_trans(car(3,i),:));
                if f ~= 0%�ж��Ƿ�������ĵ�û�г���ǰ����һ��Ŀ��
                    car(4,i) = randsrc(1,1,[1:300;now_trans(car(3,i),:)./sum(now_trans(car(3,i),:))]);
                    car(5,i) = car(5,i)+now_times(car(3,i),car(4,i))/60;%�ۼ�ʱ�䣨����ɱ��ζ���֮���ʱ�䣩

                else
                    car(5,i) = car(5,i)+1;%��ԭ��ͣһ����
                end
                car(2,i) = car(2,i) - now_distance(car(3,i),car(4,i))/1000*0.205;%����֮��ʣ�����
            end
        end
    end
    disp(t)
    %��㵽�������ִ���ж����ĳ�����ʵ�������ǲ���Ҫ�����κβ�����
    %ÿ�������ʮ�ŷֽ��е������ú�ʱ������
    if mod(t,1440) == 359
        for i = 1:100000
            if car(2,i) < unifrnd(0.15,0.3)*car(1,i) %��紥����0.15��0.3����������ľ��ȷֲ�
                change(car(4,i),t) = 1;%��¼��������
            end
        end
    Ct = min(Co.*normrnd(0.8,0.1,[1 100000]),Co);%��ص�����ʼ�ֲ�
    car(2,:) = Ct;%��2��Ϊ��ǰʱ�̵���
    car(5,:) = (1440*floor(t/1440)+360)+zeros(1,100000);%ʱ������Ϊ�������������
    end
    t = t+1;
end

%% ��������
save('all.mat')