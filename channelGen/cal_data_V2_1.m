%%�����ŵ���Ӧ��������
%���ú��� h_cal
%������� .mat�ļ����ļ�����������
%ʱ�䣺    2015��8��30��21:08:19
%���ߣ�    ���
%% �汾��  V2.1
%-Change
%---����Ϊ��ά�ռ䣬mbs��sbsλ�ò��䣬scatter��ms�ֲ���Ϊ��ά
%---����ɢ�������ɷ�ʽ
%---���ķ�Χ���߳�1400�ף�������ԭ���������ڡ�
%---ע�͵�ms���ɷ�Χ����     ̽�֣��Ƿ����
%-Todo in next version
%--ʹ�������鴢��MBSλ��

%% Definition of parameters
light_speed=299792458;
N_Scatter = 10;     %ɢ�������
N_SBS = 5;      %��
N_MS = 20;    % MS number  Mobile Station �ն�
M = 10; %MBS antenna number ������,���������0��0��ʼ���lamda/2

SBS_locations = zeros(N_SBS,3);     %����xyz����
Scatter_locations = zeros(N_Scatter,3);
MS_locations = zeros(N_MS,3);
K = 10;      % LOS factor, sqrt(K_Rician) = gamma/(1-gamma)     
                % Line of sight�Ӿྶ�� K_Rician ��ɭ˥�����ӣ�

frequency = 2100e6;      %��ʼƵ��ȡ��ͨ3g��1950MHz���У�2150MHz����
for fre_number=0:1          %!!Ϊ���ڵ��Խ�����һ��
        frequency=frequency+10e6;       %�Բ�ͬƵ�ʼ���
        opt.frequency = frequency;
        opt.K = K;
        lamda = light_speed/frequency;
        opt.lamda = lamda;
        D = lamda*0.5;  % distance between antenna elements of MBS

        H_MBS = zeros(N_MS,M);  % channel impulse responses of MBS����n��ms�Ե�m������

        H_SBS = zeros(N_MS,N_SBS);  % channel impulse responses of SBS

        %% Generate scatterer location �������ɢ����λ��
                %�߳�1400�ף�������ԭ���������ڡ�
        for i = 1:N_Scatter
            r_Scatter = 700*rand;   %�뾶
            phi_Scatter = rand*pi;  %����
            Scatter_locations(i,1) = 1400*(rand-0.5);%x����
            Scatter_locations(i,2) = 1400*(rand-0.5);%y
            Scatter_locations(i,3) = 1400*(rand-0.5);%z
            
        end

        %% Generate SBS locations
        SBS_locations = [-200,500,0;200,500,0;-500,200,0;0,200,0;500,200,0];
        % % generate random locations
        % for i = 1:N_SBS
        %     r_SBS = 500*rand;
        %     phi_SBS = pi*rand;
        %     SBS_locations(i,1) = r_SBS*cos(phi_SBS);
        %     SBS_locations(i,2) = r_SBS*sin(phi_SBS);
        % end
        %% Calulate channel responses from different MS
        for i_MS = 1:N_MS
            while(1)        %��������ms λ��
                MS_locations(i_MS,1) = 1400*(rand-0.5);
                MS_locations(i_MS,2) = 1400*(rand-0.5);
                MS_locations(i_MS,3) = 1400*(rand-0.5);
                break;
        %                 if(norm(MS_locations(i_MS,:))<=700)  �����뷶Χ�����Ƿ���ԣ�
        %                     break;
        %                 end
            end
            % calculate responses of MBS antennas
            %H1 = zeros(M,1);%?�ƺ�û��
            %H2 = zeros(M,1);
            for m = 1:M
                [H_MBS(i_MS,m)] = h_cal(MS_locations(i_MS,:) , [(m-1)*D,0,0] , Scatter_locations,opt);
            end
            % calculate responses of SBS antennas
            for i_SBS = 1:N_SBS
               [H_SBS(i_MS,i_SBS)] = h_cal(MS_locations(i_MS,:) , SBS_locations(i_SBS,:) , Scatter_locations,opt); 
            end
        end
        %% Figures
        % figure(1);
        % scatter3(Scatter_locations(:,1),Scatter_locations(:,2),Scatter_locations(:,3),'b.');
        % hold on;
        % scatter3(SBS_locations(:,1),SBS_locations(:,2),SBS_locations(:,3),'rs');
        % hold on;
        % plot3(MS_locations(:,1),MS_locations(:,2),MS_locations(:,3),'rv');
        % plot3(0,0,0,'rs','MarkerFaceColor','r');
        % hold off;
        % % show amplitudes and phases of H_MBS(1,:) and H_SBS(1,:)
        % figure(2);
        % subplot(1,2,1);plot(abs(H_MBS(1,:)));title('amplitude');
        % subplot(1,2,2);plot(unwrap(angle(H_MBS(1,:))));title('phase');
        % figure(3);
        % subplot(1,2,1);plot(abs(H_SBS(1,:)));title('amplitude');
        % subplot(1,2,2);plot(unwrap(angle(H_SBS(1,:))));title('phase');
        %% Data saving
        save(['2D_data_with_',num2str(frequency/1e6),'MHz'...
            ,num2str(M),'_antennas_fixed2_SBSs_',num2str(N_Scatter),'_scatterers.mat']...
            ,'frequency','N_Scatter','N_SBS','N_MS','SBS_locations','Scatter_locations','MS_locations','H_MBS','H_SBS');

end
