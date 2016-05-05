IE = 500;
JE = 500;    

D = 0.000015; % D=dx=dy
cluz = 2.99792458e8;
mi0 	= (4.e-7)*pi;

eps0 	= (1.e-9)/(36.*pi);

dt = 0.99*(D/(sqrt(2)*cluz));

%/*	coodenadas da fonte de excitação	*/

ic = IE/2;
jc = 1;


%/*	inicialização dos campos ( = zero)		*/

 ez=zeros(IE,JE);
 hy=zeros(IE,JE);
 hx=zeros(IE,JE);
           
 t0=20.0;
 spread=6.0;

 nsteps = 500;

 J = 1000;   % Amplitude do pulso  A/m
 stigma = 32;
 alfa = (4/stigma*dt)^2;

 for n=1:1:nsteps % /*	Loop do Tempo n	  */

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

    %pulse = exp(-0.5*((t0-n)/spread)^2); %/* fonte de excitação */

%     for j=jc+100:1:jc+200
%         for i=ic:1:ic+100
%             ez(i,j) = 0;
%         end
%     end

% //cond. de contorno:  bloco metalico
% 
% /*
% 	for (j=jc-15;j<=jc+15;j++){
% 	  ez[ic-15-5][j] = 0.0;
% 	}
% 
% 
% 	for (j=jc-15;j<=jc+15;j++){
% 	  ez[ic-15+5][j] = 0.0;
% 	}
% 
% 
% 	for (i=ic-15-5;i<=ic-15+5;i++){
% 	  ez[i][jc-15] = 0.0;
% 	}
% 
% 	for (i=ic-15-5;i<=ic-15+5;i++){
% 	  ez[i][jc+15] = 0.0;
% 	}
% */

     imagesc(D*1e+6*(1:1:IE),(D*1e+6*(1:1:JE))',ez',[-1,1]);colorbar;
    title(['\fontsize{20}Colour-scaled image plot of Ez in a spatial domain with PML boundary and at time = ',num2str(round(n*dt*1e+15)),' fs']); 
    xlabel('x (in um)','FontSize',20);
    ylabel('y (in um)','FontSize',20);
    set(gca,'FontSize',20);
    getframe;

end  %//fim do loop do tempo







