clc; clear;
fps=4000;
address1='G:\Experiments\EXP RESULT\SLA_Uncovered\set2\Mar 9\SLA_uncover_600ml_4000fps\Imaging (';
N1=1;
N2=16100;
total_length_mm=80*504/(477-15);
ww=0;
wb=0;
hh=5;
total_pixels=504; pixel_length=total_length_mm/total_pixels;
n=164;
for i=1:n
Channel_initial_x1(i)=8*(i)-round(i/2)-round(i/4); Channel_secondary_x1=Channel_initial_x1; Channel_initial_y1(i)=485; Channel_secondary_y1(i)=20;
end
transfer_below=12;
transfer_above=18; Channel_initial_x1=Channel_initial_x1+transfer_below; Channel_secondary_x1=Channel_secondary_x1+transfer_above;
tt=74;
%%%% Repairs above line totally
B=Channel_secondary_x1(1:10);
Channel_secondary_x1=-6+[B+1 B+tt-1 B+2*tt-2 B+3*tt-4 B+4*tt-6 B+5*tt-8 Channel_secondary_x1(61:n)-1];
%%%Repairs below line detailed
A=Channel_initial_x1(1:10);
Channel_initial_x1=-2+[A+1 A+tt-1 A+2*tt-3 A+3*tt-4 A+4*tt-6 A+5*tt-8 Channel_initial_x1(61:n)-1];
167
channel_NO=zeros(1,length(Channel_initial_x1)); % end of defining the rectangles velocity=zeros(1,length(Channel_secondary_x1));
N=N2-N1+1;
p=zeros(1,N); s1=zeros(length(Channel_initial_x1),N); s2=zeros(length(Channel_initial_x1),N);
for m=1:N
S=m+N1-1;
address2=num2str(S);
address3=').bmp'; address=strcat(address1,address2,address3); Q = imread(address);
Q=imrotate(Q,90);
for rr=1:length(Channel_initial_x1)
square1=Q(Channel_initial_y1(rr):Channel_initial_y1(rr)+hh,Channel_initial_x1 (rr)-wb:Channel_initial_x1(rr)+ww); square2=Q(Channel_secondary_y1(rr):Channel_secondary_y1(rr)+hh,Channel_second ary_x1(rr)-wb:Channel_secondary_x1(rr)+ww);
intensity1=sum(sum(square1))/((hh+1)*abs(wb+ww+1)); intensity2=sum(sum(square2))/((hh+1)*abs(wb+ww+1)); s1(rr,m)=intensity1;
s2(rr,m)=intensity2;
end
p(m)=m; end
for yyy=1:length(Channel_initial_x1)
loc1_s1= 1000;
loc2_s1=8000;
s11=s1(yyy,:);
168

    s22=s2(yyy,:);
    s11(1)=mean(mean(s11(1:1000)));
    s22(1)=mean(mean(s22(1:1000)));
        for kkk=1:N-1
            if abs(s11(kkk+1)-s11(kkk))>50
                s11(kkk+1)=s11(kkk);
            end
             if abs(s22(kkk+1)-s22(kkk))>50
                s22(kkk+1)=s22(kkk);
end end
figure;
tit1='Channel ';
tit2=num2str(yyy);
tit3=strcat(tit1,tit2);
plot(p,s11,'r'); hold on;
xlabel('frame number'); ylabel('Intensity'); plot(p,s22,'b');
xlabel('frame number'); ylabel('Intensity');
 % end opf defining signals
 % defining the location of peak
A=s11(loc1_s1:loc2_s1);
% end of defining the location of peak
% finding the correlation
D=zeros(1,length(s11));
for i=1:(length(s11)-length(A))+1
            B=s22(i:i+length(A)-1);
            D(i)=corr2(A,B);
        end
% end of finding the correlation
%Finding the location of maximum correlation maximum_corr=max(D);
for k=1:length(D)
169

if D(k)==maximum_corr
        loc1_s2=k;
break
end end
frame_lag=loc1_s2-loc1_s1;
% end of finding the lopcation of maximum correlation
length_traveled=pixel_length*(abs(Channel_secondary_y1(yyy)- Channel_initial_y1(yyy))+(hh/2));
time=frame_lag/fps;
if time>0 velocity(yyy)=length_traveled/time; else
yyy
                velocity(yyy)=0;
            end
channel_NO(yyy)=yyy;
end
change=velocity;
for i=1:length(velocity)
velocity(i)=change(length(velocity)+1-i); end
figure;
plot(channel_NO,velocity);
xlabel('Channel Number')
ylabel('Velocity (mm/s)')
title('Velocity Profile in channels')
filename='Velocity',;
A=velocity.';
xlswrite(filename,A);
