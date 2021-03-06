clear all;
clc;

IE = 400;
JE = 400;

D = 0.015; % D=dx=dy

cluz = 2.99792458e8;
mi0 = (4*10e-7)*pi;
eps0 = (1*10e-9)/(36*pi);

% dt = 0.999*(D/(sqrt(2)*cluz));
dt = 28.32*10e-12;

J = 1000;   % Amplitude do pulso  A/m
stigma = 32;
alfa = (4/(stigma*dt))^2;


%	coodenadas da fonte de excitação

% ic = IE/2;
% jc = JE/2;

%/*	inicialização dos campos ( = zero)

 ez=zeros(IE,JE);
 hy=zeros(IE,JE);
 hx=zeros(IE,JE);        

 nsteps = 400;
 
 A=JE*57.5/100;
 B=JE*72.5/100;
 C=IE*25/100;
 DD=IE*35/100;
 E=JE*27.5/100;
 F=JE*42.5/100;
 G=IE*45/100;
 H=IE*55/100;
 I=JE*62.5/100;
 
 jc=JE/2;
 ic=DD;
 
 L1j=JE/2;
 L1i=IE*32.5/100;
 L2i=IE/2;
 L2j=JE/2;

 PL1=zeros(nsteps);
 PL2=zeros(nsteps);
 timeArray=zeros(nsteps);

 for n=1:1:nsteps % Loop do Tempo n	

    freq = 1/(n*dt);
    lambda = cluz/freq;
     
    if n <= 20
        ez(ic,jc) = J*exp(-alfa*(n*dt-stigma*dt)^2);
    else
        ez(ic,jc) = 0;
    end
    %ez(ic,jc) = exp(-0.5*((20-n)/6)^2); %/* fonte de excitação */
    
     for j=1:1:JE-2
         for i=1:1:IE-2
                hx(i,j) = hx(i,j) + dt/mi0*(ez(i,j) - ez(i,j+1))/D;
                hy(i,j) = hy(i,j) + dt/mi0*(ez(i+1,j) - ez(i,j))/D;
         end
     end


     for j=2:1:JE-1
         for i=2:1:IE-1
                ez(i,j) = ez(i,j) + dt/eps0 * (hy(i,j) - hy(i-1,j) - hx(i,j) + hx(i,j-1))/D;
                if j==L1j && i==L1i
                    if ((ez(i,j)^2)/120*pi)*((lambda^2)/4*pi) ~=0
                        PL1(n)=10*log10(((ez(i,j)^2)/120*pi)*((lambda^2)/4*pi));
                    end
                end    
                if j==L2j && i==L2i
                    if ((ez(i,j)^2)/120*pi)*((lambda^2)/4*pi) ~=0
                        PL2(n)=10*log10(((ez(i,j)^2)/120*pi)*((lambda^2)/4*pi));
                    end
                end
         end
     end
     
     
    % construção dos prédios 
 
    for j=A:1:B
        for i=C:1:DD %Prédio A1
            ez(i,j)=0;
        end
    end     
    
     for j=E:1:F
         for i = C:1:DD % Prédio A2
            ez(i,j)=0;
        end
     end
      
     for j=A:1:B
        for i = G:1:H  %Prédio B1
            ez(i,j)=0;
        end
     end
     
     for j=E:1:F
        for i = G:1:H %Prédio B2
            ez(i,j)=0;
        end
     end
     
      for j=A:1:B
        for i = I:1:B %Prédio C1
            ez(i,j)=0;
        end
     end
     
     for j=E:1:F          %Prédio C2
        for i = I:1:B  
            ez(i,j)=0;
        end
     end
     timeArray(n) =  n*dt*1e+9;   

     imagesc(D*1e+6*(1:1:IE),(D*1e+6*(1:1:JE))',ez');colorbar;
     title(['\fontsize{20}Colour-scaled image plot of Ez in a spatial domain with PML boundary and at time = ',num2str(round(n*dt*1e+9)),' ns']); 
     xlabel('x (in um)','FontSize',20);
     ylabel('y (in um)','FontSize',20);
     set(gca,'FontSize',20);
     frame(n) = getframe;
end  %//fim do loop do tempo
%movie2avi(frame, 'eletromag.avi');
fid = fopen('pl1.txt','wt');
fprintf(fid,'%f\n',PL1);
fclose(fid);

fid = fopen('pl2.txt','wt');
fprintf(fid,'%f\n',PL2);
fclose(fid);

fid = fopen('timearray.txt','wt');
fprintf(fid,'%f\n',timeArray);
fclose(fid);
for i=9:1:400
potencia1(i-8) = PL1(i);
potencia2(i-8) = PL2(i);
end
espaco = linspace(0,391,392);
plot(espaco, potencia1);