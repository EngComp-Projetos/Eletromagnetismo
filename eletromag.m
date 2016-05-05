clear all;
clc;

IE = 200;
JE = 200;

D = 0.015; % D=dx=dy

cluz = 2.99792458e8;
mi0 = (4.e-7)*pi;
eps0 = (1.e-9)/(36.*pi);

dt = 0.99*(D/(sqrt(2.e0)*cluz));

J = 1000;   % Amplitude do pulso  A/m
stigma = 32;
alfa = (4/stigma*dt)^2;

%	coodenadas da fonte de excitação

ic = IE/2;
jc = JE/2;

%/*	inicialização dos campos ( = zero)

 ez=zeros(IE,JE);
 hy=zeros(IE,JE);
 hx=zeros(IE,JE);        

 t0=20.0;
 spread=6.0;

 nsteps = 500;
 
 A=JE*57.5/100;
 B=JE*72.5/100;
 

 for n=1:1:nsteps % Loop do Tempo n	

    if n <= 20
        ez(ic,jc) = J*exp(-alfa*(n-stigma*dt)^2);
    end
    
    
     for j=1:1:JE-2
         for i=1:1:IE-2
                hx(i,j) = hx(i,j) + dt/mi0*(ez(i,j) -ez(i,j+1))/D;
                hy(i,j) = hy(i,j) + dt/mi0*(ez(i+1,j)-ez(i,j))/D;
         end
     end


    
     for j=2:1:JE-2
         for i=2:1:IE-2
                ez(i,j) = ez(i,j) + dt/eps0 * (hy(i,j) - hy(i-1,j) - hx(i,j) + hx(i,j-1))/D;
         end
     end
     
     
    for j=JE*57.5/100:1:JE*72.5/100
        for i=IE*25/100:1:IE*35/100 %Prédio A1
            ez(i,j)=0;
        end
    end     
     for j=JE*27.5/100:1:JE*42.5/100
         for i = IE*25/100:1:IE*35/100 % Prédio A2
            ez(i,j)=0;
        end
     end
      
     for j=JE*57.5/100:1:JE*72.5/100
        for i = IE*45/100:1:IE*55/100  %Prédio B1
            ez(i,j)=0;
        end
     end
     
     for j=JE*27.5/100:1:JE*42.5/100
        for i = IE*45/100:1:IE*55/100 %Prédio B2
            ez(i,j)=0;
        end
     end
     
      for j=JE*57.5/100:1:JE*72.5/100
        for i = JE*62.5/100:1:JE*72.5/100 %Prédio C1
            ez(i,j)=0;
        end
     end
     
     for j=JE*27.5/100:1:JE*42.5/100          %Prédio C2
        for i = JE*62.5/100:1:JE*72.5/100  
            ez(i,j)=0;
        end
     end

    %pulse = exp(-0.5*((t0-n)/spread)^2); %/* fonte de excitação */

     imagesc(D*1e+6*(1:1:IE),(D*1e+6*(1:1:JE))',ez',[-1,1]);colorbar;
    title(['\fontsize{20}Colour-scaled image plot of Ez in a spatial domain with PML boundary and at time = ',num2str(round(n*dt*1e+15)),' fs']); 
    xlabel('x (in um)','FontSize',20);
    ylabel('y (in um)','FontSize',20);
    set(gca,'FontSize',20);
    getframe;

end  %//fim do loop do tempo







