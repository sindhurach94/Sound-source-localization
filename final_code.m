clc;
clear all;
close all;
source = randn(1500,1);                                        %taking a random source as source
source_X = 9;                                                  %assuming the source x location
source_Y = 5;                                                  %assuming the source y location
Mics = 4;                                                   %number of microphones
mic_spacing = 3;                                               %distance between microphones
c = 343;                                                       %speed of sound
arraywidth = (Mics - 1)*mic_spacing;                        %width of array of microphones
mic_X = linspace(0,arraywidth,Mics);                        %x locations of the mics
mic_Y = zeros(1,Mics);                                      %y locations of the mics
fs = 1200;                                                     %sampling frequency
%distance of each microphone from the source
dist = sqrt(((source_X-mic_X).^2)+((source_Y-mic_Y).^2));
T = (dist/c)*fs;
    

for i = 1:Mics-1                                               %calculation of delays in samples
    dt(i) = T(1)-T(i+1)
end                
    delays_theo= dt/fs                                         %theoritical delays
    
    Dt = round(dt*fs);                                         %samples 
    
    % 1st filter with length 200
    t = [-100:100]; y = sinc(t-T(1));
    s0 = filter(y,1,source);
    Y1 = sinc(t-T(2));
    s1 = filter(Y1,1,source);
    Y2 = sinc(t-T(3));
    s2 = filter(Y2,1,source);
    Y3 = sinc(t-T(4));
    s3 = filter(Y3,1,source);

     figure(1)
     plot(s1);
   hold on;
   plot(s2);
   hold on;
   plot(s3);
    title('Filter coefficients of first filter with delay ti');
   xlabel('Number of samples');
   ylabel('Magnitude');
    
    
    nord = 100;
% 2nd filter with length nord/2
  
t1 = [-50:50]; y1 = sinc(t1);
    S0 = filter(y1,1,s0);
    S1 = filter(y1,1,s1);
    S2 = filter(y1,1,s2);
    S3 = filter(y1,1,s3);
     mu = 0.01;
  S = [S0 S1 S2 S3];
%magnitude and phase plots using lms algorithm
[A1] = lms(s0,S1,mu,nord);
A= A1(1500,:);
    figure(2)
    subplot(2,1,1)
    stem(A);
    xlabel('number of samples');
    ylabel('magnitude');
    title('Filter coefficients for microphone 2 with microphone 1 as reference');
    %phase
    q=((pi/nord):(pi/nord):pi);
    p1=unwrap(-angle((fft(A))));
     subplot(2,1,2)
    stem(q/pi,unwrap(angle((fft(A)))));
    xlabel('normalized frequency (w/pi)');
    ylabel('Phase');
    title('Phase of filter coefficients for microphone 2 with microphone 1 as reference');
    
    [A2] = lms(s0,S2,mu,nord);
B= A2(1500,:);
    figure(3)
    subplot(2,1,1)
    stem(B);
    xlabel('number of samples');
    ylabel('magnitude');
    title('Filter coefficients for microphone 3 with microphone 1 as reference');
    %phase
    q=((pi/nord):(pi/nord):pi);
    p2=unwrap(-angle((fft(B))));
   subplot(2,1,2)
    stem(q/pi,unwrap(angle((fft(B)))));
    xlabel('normalized frequency (w/pi)');
    ylabel('Phase');
    title('Phase of filter coefficients for microphone 3 with microphone 1 as reference');
    
     [A3] = lms(s0,S3,mu,nord);
C= A3(1500,:);
    figure(4)
    subplot(2,1,1)
    stem(C);
    xlabel('number of samples');
    ylabel('magnitude');
    title('Filter coefficients for microphone 4 with microphone 1 as reference');
    %phase
    q=((pi/nord):(pi/nord):pi);
    p3=unwrap(-angle((fft(C))));
subplot(2,1,2)
    stem(q/pi,unwrap(angle((fft(C)))));
    xlabel('normalized frequency (w/pi)');
    ylabel('Phase');
    title('Phase of filter coefficients for microphone 4 with microphone 1 as reference');
    
    k1=q'\p1';
 T1=((nord+(-k1))/2)/fs;
  k2=q'\p2';
 T2=((nord+(-k2))/2)/fs;
  k3=q'\p3';
 T3=((nord+(-k3))/2)/fs;
 Tr=[T1 T2 T3]

 %%Steepest descent algorithm to localize the source
 syms x y  
 
 for i=1:Mics-1
 F(:,i) = (sqrt((x-i*mic_spacing)^2+y^2)-sqrt(x^2+y^2));        %defining the F function
 end

 G_fun =sum(((F+Tr*c)).^2); 
                                                       %gradiant estimate
                                                        
 Gd1= matlabFunction(diff(G_fun,(x)));
 Gd2=  matlabFunction(diff(G_fun,(y)));
 
  N=10000;                                              %number of iterations

mu=.5;
 mx=1;
 my=1;
 zx=zeros(1,N).';
 zy=zeros(1,N).';
 zx(1)=mx-mu*Gd1(mx,my);
 zy(1)=my-mu*Gd2(mx,my);
 for i=2:N 
     zx(i)=zx(i-1)-mu*Gd1(zx(i-1,1),zy(i-1,1));
     zy(i)=zy(i-1)-mu*Gd2(zx(i-1,1),zy(i-1,1));

 end 
 display(zx(i));
 display(zy(i)) 
 
%%convergence
 figure
 plot(zx);
 hold on;
 plot(zy,'r');
xlabel('number of iterations');
 ylabel('convergence of positions x and y');
 title('plot of convergence for 4 mics');