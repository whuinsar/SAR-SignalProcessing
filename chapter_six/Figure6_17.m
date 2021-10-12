clc
clear
close all
%% ��������
%  ��֪����--�����������
R_eta_c = 20e+3;                % ������б��
Tr = 2.5e-6;                    % ��������ʱ��
Kr = 20e+12;                    % �������Ƶ��
alpha_os_r = 1.2;               % �����������
Nrg = 320;                      % �����߲�������
%  �������--�����������
Bw = abs(Kr)*Tr;                % �����źŴ���
Fr = alpha_os_r*Bw;             % �����������
Nr = round(Fr*Tr);              % �����������(�������г���)
%  ��֪����--����λ�����
c = 3e+8;                       % ��Ŵ����ٶ�
Vr = 150;                       % ��Ч�״��ٶ�
Vs = Vr;                        % ����ƽ̨�ٶ�
Vg = Vr;                        % ����ɨ���ٶ�
f0 = 5.3e+9;                    % �״﹤��Ƶ��
Delta_f_dop = 80;               % �����մ���
alpha_os_a = 1.25;              % ��λ��������
Naz = 256;                      % ��������
theta_r_c = +21.9*pi/180;       % ����б�ӽ�
%  �������--����λ�����
lambda = c/f0;                  % �״﹤������
t_eta_c = -R_eta_c*sin(theta_r_c)/Vr;
                                % �������Ĵ�Խʱ��
f_eta_c = 2*Vr*sin(theta_r_c)/lambda;
                                % ����������Ƶ��
La = 0.886*2*Vs*cos(theta_r_c)/Delta_f_dop;               
                                % ʵ�����߳���
Fa = alpha_os_a*Delta_f_dop;    % ��λ�������
Ta = 0.886*lambda*R_eta_c/(La*Vg*cos(theta_r_c));
                                % Ŀ������ʱ��
R0 = R_eta_c*cos(theta_r_c);    % ���б��
Ka = 2*Vr^2*cos(theta_r_c)^2/lambda/R0;              
                                % ��λ���Ƶ��
theta_bw = 0.886*lambda/La;     % ��λ��3dB��������
theta_syn = Vs/Vg*theta_bw;     % �ϳɽǿ���
Ls = R_eta_c*theta_syn;         % �ϳɿ׾�����
%  ��������
rho_r = c/(2*Fr);               % ������ֱ���
rho_a = La/2;                   % ������ֱ���
Trg = Nrg/Fr;                   % ��������ʱ��
Taz = Naz/Fa;                   % Ŀ������ʱ��
d_t_tau = 1/Fr;                 % �������ʱ����
d_t_eta = 1/Fa;                 % ��λ����ʱ����
d_f_tau = Fr/Nrg;               % �������Ƶ�ʼ��    
d_f_eta = Fa/Naz;               % ��λ����Ƶ�ʼ��
%% Ŀ������
%  ����Ŀ�������ھ�����֮��ľ���
A_r =    0;  A_a =   0;                                 % A��λ��
B_r = -150; B_a = -180;                                 % B��λ��
C_r = -100; C_a =  +80;                                 % C��λ��
D_r = +100; D_a = C_a + (D_r-C_r)*tan(theta_r_c);       % D��λ��
%  �õ�Ŀ�������ھ����ĵ�λ������
A_x = R0 + A_r; A_Y = A_a;                              % A������
B_x = R0 + B_r; B_Y = B_a;                              % B������
C_x = R0 + C_r; C_Y = C_a;                              % C������
D_x = R0 + D_r; D_Y = D_a;                              % D������
NPosition = [A_x,A_Y;
             B_x,B_Y;
             C_x,C_Y;
             D_x,D_Y;];                                 % ��������
fprintf( 'A������Ϊ[%+3.3f��%+3.3f]km\n', NPosition(1,1)/1e3, NPosition(1,2)/1e3 );
fprintf( 'B������Ϊ[%+3.3f��%+3.3f]km\n', NPosition(2,1)/1e3, NPosition(2,2)/1e3 );
fprintf( 'C������Ϊ[%+3.3f��%+3.3f]km\n', NPosition(3,1)/1e3, NPosition(3,2)/1e3 );
fprintf( 'D������Ϊ[%+3.3f��%+3.3f]km\n', NPosition(4,1)/1e3, NPosition(4,2)/1e3 );
%  �õ�Ŀ���Ĳ������Ĵ�Խʱ��
Ntarget = 4;
Tar_t_eta_c = zeros(1,Ntarget);
for i = 1 : Ntarget
    DeltaX = NPosition(i,2) - NPosition(i,1)*tan(theta_r_c);
    Tar_t_eta_c(i) = DeltaX/Vs;
end
%  �õ�Ŀ���ľ����������ʱ��
Tar_t_eta_0 = zeros(1,Ntarget);
for i = 1 : Ntarget
    Tar_t_eta_0(i) = NPosition(i,2)/Vr;
end
%% ��������
%  ʱ����� �Ծ����ĵ��������ʱ����Ϊ��λ�����
t_tau = (-Trg/2:d_t_tau:Trg/2-d_t_tau) + 2*R_eta_c/c;   % ����ʱ�����
t_eta = (-Taz/2:d_t_eta:Taz/2-d_t_eta) + t_eta_c(1);    % ��λʱ�����
%  ���ȱ���
r_tau = (t_tau*c/2)*cos(theta_r_c);                     % ���볤�ȱ���                                                    
%  Ƶ�ʱ��� 
f_tau = fftshift(-Fr/2:d_f_tau:Fr/2-d_f_tau);           % ����Ƶ�ʱ���
f_tau = f_tau - round((f_tau-0)/Fr)*Fr;                 % ����Ƶ�ʱ���(�ɹ۲�Ƶ��)                          
f_eta = fftshift(-Fa/2:d_f_eta:Fa/2-d_f_eta);           % ��λƵ�ʱ���
f_eta = f_eta - round((f_eta-f_eta_c(1))/Fa)*Fa;        % ��λƵ�ʱ���(�ɹ۲�Ƶ��)
%% ��������   
%  �Ծ���ʱ��ΪX�ᣬ��λʱ��ΪY��
[t_tauX,t_etaY] = meshgrid(t_tau,t_eta);                % ���þ���ʱ��-��λʱ���ά��������
%  �Ծ��볤��ΪX�ᣬ��λƵ��ΪY��                                                                                                            
[r_tauX,f_etaY] = meshgrid(r_tau,f_eta);                % ���þ���ʱ��-��λƵ���ά��������
%  �Ծ���Ƶ��ΪX�ᣬ��λƵ��ΪY��                                                                                                            
[f_tau_X,f_eta_Y] = meshgrid(f_tau,f_eta);              % ����Ƶ��ʱ��-��λƵ���ά��������
%% �ź�����--��ԭʼ�ز��ź�  
tic
wait_title = waitbar(0,'��ʼ�����״�ԭʼ�ز����� ...');  
pause(1);
srt = zeros(Naz,Nrg);
for i = 1 : Ntarget
    %  ����Ŀ����˲ʱб��
    R_eta = sqrt( NPosition(i,1)^2 +...
                  Vr^2*(t_etaY-Tar_t_eta_0(i)).^2 ); 
    A0 = [1,1,1,1]*exp(+1j*0);   
    wr = (abs(t_tauX-2*R_eta/c) <= Tr/2);                               
    wa = sinc(0.886*atan(Vg*(t_etaY-Tar_t_eta_c(i))/NPosition(i,1))/theta_bw).^2;      
    srt_tar = A0(i)*wr.*wa.*exp(-1j*4*pi*f0*R_eta/c)...
                          .*exp(+1j*pi*Kr*(t_tauX-2*R_eta/c).^2);                                                        
    srt = srt + srt_tar;  
    
    pause(0.001);
    Time_Trans   = Time_Transform(toc);
    Time_Disp    = Time_Display(Time_Trans);
    Display_Data = num2str(roundn(i/Ntarget*100,-1));
    Display_Str  = ['Computation Progress ... ',Display_Data,'%',' --- ',...
                    'Using Time: ',Time_Disp];
    waitbar(i/Ntarget,wait_title,Display_Str)
    
end
pause(1);
close(wait_title);
toc
%% �ź�����--��һ�ξ���ѹ��
window = kaiser(Nrg,2.5)';                              % ʱ��
Window = fftshift(window);                              % Ƶ��
Hrf = Window.*exp(+1j*pi*f_tau_X.^2/Kr);  
%% �ź�����--�����ξ���ѹ����ͨ����ʽ��ʵ��(��Ϊ��R0��f_etaYΪ����أ���������ٶ��������޹�)
Drd0 = sqrt(1-lambda^2*f_eta_c^2/(4*Vr^2));             % ������������е��㶯����
Ksrc = 2*Vr^2*f0^3*Drd0/(c*R0*f_eta_c^2);               % ���벹����Ƶ��
Hsrcf = exp(-1j*pi*f_tau_X.^2/Ksrc);  
%% �ź�����--��һ�ξ���ѹ���Ͷ��ξ���ѹ���ĺϲ�����
Km = Kr*Ksrc/(Ksrc-Kr);                                 % ����ϲ���Ƶ��
Hmf = Window.*exp(+1j*pi*f_tau_X.^2/Km);
%  ƥ���˲�
Srf = fft(srt,Nrg,2);
Soutrf = Srf.*Hmf;
soutrt = ifft(Soutrf,Nrg,2);
%% �ź�����--����λ����Ҷ�任
Srdf = fft(soutrt,Naz,1);
%% �ź�����--�������㶯У��
Drd = sqrt(1-lambda^2*f_etaY.^2/(4*Vr^2));              % ������������е��㶯����
RCM = r_tauX./Drd-r_tauX;                               % ��ҪУ���ľ����㶯��
RCM = R0 + RCM - R_eta_c;                               % �������㶯��ת����ԭͼ������ϵ��
offset = RCM/rho_r;                                     % �������㶯��ת��Ϊ���뵥Ԫƫ����
%  �����ֵϵ����
x_tmp = repmat(-4:3,[16,1]);                            % ��ֵ����                          
x_tmp = x_tmp + repmat(((1:16)/16).',[1,8]);            % ����λ��
hx = sinc(x_tmp);                                       % ���ɲ�ֵ��
kwin = repmat(kaiser(8,2.5).',[16,1]);                  % �Ӵ�
hx = kwin.*hx;
hx = hx./repmat(sum(hx,2),[1,8]);                       % �˵Ĺ�һ��
%  ��ֵ��У��
tic
wait_title = waitbar(0,'��ʼ���о����㶯У�� ...');  
pause(1);
Srdf_rcm = zeros(Naz,Nrg);
for a_tmp = 1 : Naz
    for r_tmp = 1 : Nrg
        offset_ceil = ceil(offset(a_tmp,r_tmp));
        offset_frac = round((offset_ceil - offset(a_tmp,r_tmp)) * 16);
        if offset_frac == 0
           Srdf_rcm(a_tmp,r_tmp) = Srdf(a_tmp,ceil(mod(r_tmp+offset_ceil-0.1,Nrg))); 
        else
           Srdf_rcm(a_tmp,r_tmp) = Srdf(a_tmp,ceil(mod((r_tmp+offset_ceil-4:r_tmp+offset_ceil+3)-0.1,Nrg)))*hx(offset_frac,:).';
        end
    end
    
    pause(0.001);
    Time_Trans   = Time_Transform(toc);
    Time_Disp    = Time_Display(Time_Trans);
    Display_Data = num2str(roundn(a_tmp/Naz*100,-1));
    Display_Str  = ['Computation Progress ... ',Display_Data,'%',' --- ',...
                    'Using Time: ',Time_Disp];
    waitbar(a_tmp/Naz,wait_title,Display_Str)
    
end
pause(1);
close(wait_title);
toc
%% �ź�����--����λѹ��
%  �����˲���
Haf = exp(+1j*4*pi*f0*r_tauX.*Drd/c);
H_offset = exp(-1j*2*pi*f_etaY.*t_eta_c);
%  ƥ���˲�
Soutaf = Srdf_rcm.*Haf.*H_offset;
soutat = ifft(Soutaf,Naz,1);
%% ��ͼ
H1 = figure();
set(H1,'position',[100,100,600,600]); 
subplot(221),imagesc( abs(ifft(Srf.*Hrf,Nrg,2)))
%  axis([0 Naz,0 Nrg])
xlabel('������(������)��'),ylabel('����λ��(������)'),title('(a)һ�ξ���ѹ��')
subplot(222),imagesc( abs(ifft(Srf.*Hrf.*Hsrcf,Nrg,2)))
%  axis([0 Naz,0 Nrg])
%  axis([0 Naz,0 Nrg])
xlabel('������(������)��'),ylabel('��λƵ��(������)��'),title('(b)���ξ���ѹ��')
subplot(223),imagesc(  abs(Srdf)),set(gca,'YDir','normal')
%  axis([0 Naz,0 Nrg])
xlabel('������(������)��'),ylabel('��λƵ��(������)��'),title('(c)��λ����ٸ���Ҷ�任�������')
subplot(224),imagesc( abs(soutat))
xlabel('������(������)��'),ylabel('����λ��(������)'),title('(d)RCMC�ͷ�Ϊѹ���������')
sgtitle('ͼ6.17 ��ʽ3�¶��ξ���ѹ���ľ�ȷʵ��','Fontsize',16,'color','k')