%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%   Plot salt distribution during simulation%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Create a movie for visualisation of the whole simulation process

% Make x and y matrix (nodes)
x_matrix=reshape(nod(1).terms{xnod_idx},[inp.nn1,inp.nn2]);
y_matrix=reshape(nod(1).terms{ynod_idx},[inp.nn1,inp.nn2]);

% Make x and y matrix (elements)
xele_matrix=reshape(ele(1).terms{xele_idx},[inp.nn1-1,inp.nn2-1]);
yele_matrix=reshape(ele(1).terms{yele_idx},[inp.nn1-1,inp.nn2-1]);

A_Find_dat = textread('Find_D3L1.dat');
A_HydrulicConducitivy_dat = A_Find_dat(:,3);

Time_range = 1:130;


Pos_left = 0.1;
Pos_bottom = 0.33;
Pos_width = 0.8;
Pos_height = 0.43;
min_x = 1.4;
max_x = 3.4;
min_y = 0;
max_y = 0.7;
ax11 = subplot('position',[Pos_left,Pos_bottom,Pos_width,Pos_height])
colormap(ax11,jet);
%Make color bar and ensure the color will not change during the movie
caxis([0, 0.035]);%salinity range
colorbar('YTick', 0:0.005:0.035, 'YTickLabel', {' ', '0.005', '0.01', '0.015', '0.02', '0.025', '0.03', '0.035'});
b=colorbar;
set (b, 'ylim', [0 0.035])
b.Label.String ='Salinity (ppt)';
%Make title and label 
title('Concentration contour');
xlabel('Distance x (m)')
ylabel('Depth (m)')
set(gca,'nextplot','replacechildren'); 
set(gcf,'outerposition',get(0,'screensize'));
xlim([min_x max_x])
ylim([min_y max_y])
axis([min_x max_x min_y max_y])
set(gca,'YTick',[min_y:0.35:max_y],'fontname','times new roman','fontsize',13);
set(gca,'YTickLabel',{'0.0','0.35','0.7'});
set(gca,'XTick',[min_x:0.1:max_x],'fontname','times new roman','fontsize',13);
%set(gca,'XTickLabel',{'2.0','1.9','1.8','1.7','1.6','1.5','1.4','1.3','1.2','1.1'...
%    ,'1.0','0.9','0.8','0.7','0.6','0.5','0.4','0.3','0.2','0.1','0.0'});
set(gca,'yaxislocation','right');
%Make movie things
mov =  VideoWriter('concerntration.avi');% avifile('pvc1.avi','quality',qt,'compression','indeo5','fps',fs);
mov.FrameRate = 30;mov.Quality=100;%FrameRate is the fps, Quality range from 1 to 100
open(mov);
for i = Time_range
c_matrixi  = reshape(nod(i).terms{c_idx},[inp.nn1,inp.nn2]);
%Find the index of reservoir node and element 
High_K = 3.5e-07;
High_K_Selected = High_K/10;
High_K_Reservoir = 3.51e-07;
Above_resservoirwater_indx = find(A_HydrulicConducitivy_dat>=High_K...
    &A_HydrulicConducitivy_dat<High_K_Reservoir);
%Modify the data in reservoir (Concentration and velocity)
C_interp = interp2(c_matrixi,2,'liner');
c_matrix_interp = C_interp(4:4:561,4:4:1921)%interp 3 times
c_elecentral = reshape(c_matrix_interp,[inp.ne,1]);
c_elecentral (Above_resservoirwater_indx) = nan;
c_matrix  = reshape(c_elecentral,[inp.nn1-1,inp.nn2-1]);
contourf(xele_matrix,yele_matrix,c_matrix,100,'LineStyle','none')
hold on
%line for D3_L1
line([3 3.12],[0.35 0.35],'Color','w','LineStyle','-','LineWidth',5);
line([3.12 3.12],[0.35 0.21],'Color','w','LineStyle','-','LineWidth',5);
line([3.12 3.17],[0.21 0.21],'Color','w','LineStyle','-','LineWidth',5);
line([3.17 3.17],[0.21 0.35],'Color','w','LineStyle','-','LineWidth',5);
line([3.17 3.4],[0.35 0.35],'Color','w','LineStyle','-','LineWidth',5);
line([2.1 3.0],[0.68 0.35],'Color','w','LineStyle','-','LineWidth',5);
    F = getframe(gcf); % save the current figure
    writeVideo(mov,F);% add it as the next frame of the movie
end
close(mov);
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%   Tidally-average salinity _ salinization extent%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Basic value of mesh
Area_reservoir = 2.35714e-5;
Area_DP = 2.5e-5;
Volume_reservoir = Area_reservoir*inp.z;
Volume_DP = Area_DP*inp.z;
c_sea = 0.035;%ppt
sum_number_1 = 2;%control the sum of matrix to get one  Rows (1) or one Columns (2)
sum_number_2 = 1;%control the sum of matrix to get one  Rows (1) or one Columns (2)
%Calculate the tidally averaged salinity and reshape the salinity matrix
c_matrix  = reshape(Salinity_D3L1Steadycycle_tidally(:,4),[inp.nn1,inp.nn2]);%Get the salinity of tidally averaged
C_interp = interp2(c_matrix,2,'liner');%interp 3 times
c_matrix_interp = C_interp(4:4:561,4:4:1921)
c_elecentral = reshape(c_matrix_interp,[inp.ne,1]);
%Find the index of reservoir water and deep pool water
%Get out of the velocity of the reservoir water 
A_Find_dat = textread('Find_D3L1.dat');
A_HydrulicConducitivy_dat = A_Find_dat(:,3)
%Find the index of reservoir node and element 
High_K = 3.5e-07
High_K_Selected = High_K/10
High_K_Reservoir = 3.51e-07;
High_K_DP = 3.52e-07;
ReservoirWater_indx = find(A_HydrulicConducitivy_dat>High_K...
    &A_HydrulicConducitivy_dat<=High_K_Reservoir);
DPWater_indx = find(A_HydrulicConducitivy_dat>High_K_Reservoir...
    &A_HydrulicConducitivy_dat<=High_K_DP);
ReservoirWater_Salinity = c_elecentral(ReservoirWater_indx);
DPWater_Salinity = c_elecentral(DPWater_indx);
%Calulation of the saliniztaion extent of coastal reservoir
ReservoirWater_Rho = inp.rhow0 + inp.drwdu.*ReservoirWater_Salinity;%Get the density
DPWater_Rho = inp.rhow0 + inp.drwdu.*DPWater_Salinity;%Get the density
%Calculate the averaged salinity 
D3L1_ReWater_SaltMass = ReservoirWater_Salinity.*ReservoirWater_Rho.*Volume_reservoir;
D3L1_ReWater_SolutionMass = ReservoirWater_Rho.*Volume_reservoir;
D3L1_DP_SaltMass = DPWater_Salinity.*DPWater_Rho.*Volume_DP;
D3L1_DP_SolutionMass = DPWater_Rho.*Volume_DP;
D3L1_Total_SaltMass = cat (1,D3L1_ReWater_SaltMass,D3L1_DP_SaltMass)
D3L1_Total_SolutionMass = cat (1,D3L1_ReWater_SolutionMass,D3L1_DP_SolutionMass)
%Calculate the salinization extent
D3L1_ReWater_Average_salinity = sum(D3L1_ReWater_SaltMass)/sum(D3L1_ReWater_SolutionMass);
D3L1_DP_Average_salinity = sum(D3L1_DP_SaltMass)/sum(D3L1_DP_SolutionMass);
D3L1_Total_Average_salinity = sum(D3L1_Total_SaltMass)/sum(D3L1_Total_SolutionMass);
%
D3L1_ReWater_Salinization = D3L1_ReWater_Average_salinity/c_sea
D3L1_DP_Salinization = D3L1_DP_Average_salinity/c_sea
D3L1_Total_Salinization = D3L1_Total_Average_salinity/c_sea
save('D3L1_Salinization','D3L1_ReWater_Salinization','D3L1_DP_Salinization','D3L1_Total_Salinization')


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Calculation and output EFLUX and INFLUX of water and solute
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
nod  = readNOD(fil.basename);
ele  = readELE(fil.basename);
RSide_ele_number = 70;
RBed_ele_number = 80;
Time_range_min = 1
Time_range_max = 90
Time_range = 1:90
RSide_ele_y = 1:70;
RSide_ele_x = 400;
RBed_ele_y = 71;
RBed_ele_x = 401:480;
RBedL_ele_x = 401:423;
RBedL_ele_y = 71;
LMesh_ele_x = 424
LMesh_ele_y = 71;
RDPL_ele_x = 424;
RDPL_ele_y = 72:98;
RDPB_ele_x = 425:434;
RDPB_ele_y = 99;
RDPR_ele_x = 435;
RDPR_ele_y = 72:98;
RMesh_ele_x = 435;
RMesh_ele_y = 71;
RBedR_ele_x = 436:480;
RBedR_ele_y = 71;
Length_RSide_X = 0.9;
Length_RSide_y = 0.33;
Length_RSide_Total = (Length_RSide_X^2+Length_RSide_y^2)^0.5;
Length_RSide_mesh = Length_RSide_Total/((inp.nn1-1)/2);
SinAng = Length_RSide_y/Length_RSide_Total;%Angle of Reservoir Side
CosAng = Length_RSide_X/Length_RSide_Total;%Angle of Reservoir Side
Length_RBed_Total = 0.4;
Length_RBed_mesh = Length_RBed_Total/40;
Volume_RSide_mesh = inp.z*Length_RSide_mesh*inp.por; %(m^2)
Volume_RBed_mesh = inp.z*Length_RBed_mesh*inp.por; %(m^2)

vx_matrix_RSide = zeros (length(RSide_ele_y),1);
vy_matrix_RSide = zeros (length(RSide_ele_y),1);
vx_matrix_RBedL = zeros (length(RBedL_ele_x),1);
vy_matrix_RBedL = zeros (length(RBedL_ele_x),1);
vx_matrix_LMesh = zeros (length(LMesh_ele_x),1);
vy_matrix_LMesh = zeros (length(LMesh_ele_x),1);
vx_matrix_DPL = zeros (length(RDPL_ele_y),1);
vy_matrix_DPL = zeros (length(RDPL_ele_y),1);
vx_matrix_DPB = zeros (length(RDPB_ele_x),1);
vy_matrix_DPB = zeros (length(RDPB_ele_x),1);
vx_matrix_DPR = zeros (length(RDPR_ele_y),1);
vy_matrix_DPR = zeros (length(RDPR_ele_y),1);
vx_matrix_RMesh = zeros (length(RMesh_ele_x),1);
vy_matrix_RMesh = zeros (length(RMesh_ele_x),1);
vx_matrix_RBedR = zeros (length(RBedR_ele_x),1);
vy_matrix_RBedR = zeros (length(RBedR_ele_x),1);

c_matrix_RSide = zeros(length(RSide_ele_y),1)
c_matrix_RBedL = zeros(length(RBedL_ele_x),1)
c_matrix_LMesh = zeros(length(LMesh_ele_x),1)
c_matrix_DPL = zeros(length(RDPL_ele_y),1)
c_matrix_DPB = zeros(length(RDPB_ele_x),1)
c_matrix_DPR = zeros(length(RDPR_ele_y),1)
c_matrix_RMesh = zeros(length(RMesh_ele_x),1)
c_matrix_RBedR = zeros(length(RBedR_ele_x),1)

for i = Time_range
vx_matrix = reshape(ele(i).terms{vx_idx},[inp.nn1-1,inp.nn2-1]);
vy_matrix = reshape(ele(i).terms{vy_idx},[inp.nn1-1,inp.nn2-1]);
vx_matrix_RSide(:,i) = vx_matrix(RSide_ele_y,RSide_ele_x)
vy_matrix_RSide(:,i) = vy_matrix(RSide_ele_y,RSide_ele_x)
vx_matrix_RBedL(:,i) = vx_matrix(RBedL_ele_y,RBedL_ele_x)
vy_matrix_RBedL(:,i) = vy_matrix(RBedL_ele_y,RBedL_ele_x)
vx_matrix_LMesh(:,i) = vx_matrix(LMesh_ele_y,LMesh_ele_x)
vy_matrix_LMesh(:,i) = vy_matrix(LMesh_ele_y,LMesh_ele_x)
vx_matrix_DPL(:,i) = vx_matrix(RDPL_ele_y,RDPL_ele_x)
vy_matrix_DPL(:,i) = vy_matrix(RDPL_ele_y,RDPL_ele_x)
vx_matrix_DPB(:,i) = vx_matrix(RDPB_ele_y,RDPB_ele_x)
vy_matrix_DPB(:,i) = vy_matrix(RDPB_ele_y,RDPB_ele_x)
vx_matrix_DPR(:,i) = vx_matrix(RDPR_ele_y,RDPR_ele_x)
vy_matrix_DPR(:,i) = vy_matrix(RDPR_ele_y,RDPR_ele_x)
vx_matrix_RMesh(:,i) = vx_matrix(RMesh_ele_y,RMesh_ele_x)
vy_matrix_RMesh(:,i) = vy_matrix(RMesh_ele_y,RMesh_ele_x)
vx_matrix_RBedR(:,i) = vx_matrix(RBedR_ele_y,RBedR_ele_x)
vy_matrix_RBedR(:,i) = vy_matrix(RBedR_ele_y,RBedR_ele_x)
end
xele_matrix = reshape(ele(1).terms{xele_idx},[inp.nn1-1,inp.nn2-1])
xele_matrix_RSide = xele_matrix(RSide_ele_y,RSide_ele_x)
xele_matrix_RBed_1 = xele_matrix(RBed_ele_y,RBed_ele_x)
xele_matrix_RBed = transpose(xele_matrix_RBed_1)
xele_matrix_upperboudary_1 = 1.4:0.7/33:2.1
xele_matrix_upperboudary = transpose(xele_matrix_upperboudary_1)
x = cat (1,xele_matrix_upperboudary,xele_matrix_RSide,xele_matrix_RBed)
%Calculation of each part of Water flux
Water_flux_RSide = (vx_matrix_RSide*SinAng+vy_matrix_RSide*CosAng)*Volume_RSide_mesh
Water_flux_RBedL = vy_matrix_RBedL*Volume_RBed_mesh
Water_flux_LMesh = vy_matrix_LMesh*Volume_RBed_mesh + vx_matrix_LMesh*Volume_RBed_mesh
Water_flux_DPL = vx_matrix_DPL*Volume_RBed_mesh
Water_flux_DPB = vy_matrix_DPB*Volume_RBed_mesh
Water_flux_DPR = vx_matrix_DPR*(-1)*Volume_RBed_mesh
Water_flux_RMesh = vy_matrix_RMesh*Volume_RBed_mesh + vx_matrix_RMesh*(-1)*Volume_RBed_mesh
Water_flux_RBedR = vy_matrix_RBedR*Volume_RBed_mesh
%Combined and output Water flux
Water_flux = cat (1,Water_flux_RSide,Water_flux_RBedL,Water_flux_LMesh + sum(Water_flux_DPL)...
    ,Water_flux_DPB,sum(Water_flux_DPR) + Water_flux_RMesh,Water_flux_RBedR)
D3L1_Waterflux_sum_interface = sum(Water_flux,2)/(Time_range_max*inp.z)
save('D3L1_Waterflux_sum_interface','D3L1_Waterflux_sum_interface')
% Interploation salinity(element central) :Water_flux

for i = Time_range
c_matrixi = reshape(nod(i).terms{c_idx},[inp.nn1,inp.nn2]); % Initial concentration
C_interp = interp2(c_matrixi,2,'liner');%interp 3 times
c_matrix_interp = C_interp(4:4:561,4:4:1921);%interp 3 times
c_matrix_RSide(:,i) = c_matrix_interp(RSide_ele_y,RSide_ele_x)
c_matrix_RBedL(:,i) = c_matrix_interp(RBedL_ele_y,RBedL_ele_x)
c_matrix_LMesh(:,i) = c_matrix_interp(LMesh_ele_y,LMesh_ele_x)
c_matrix_DPL(:,i) = c_matrix_interp(RDPL_ele_y,RDPL_ele_x)
c_matrix_DPB(:,i) = c_matrix_interp(RDPB_ele_y,RDPB_ele_x)
c_matrix_DPR(:,i) = c_matrix_interp(RDPR_ele_y,RDPR_ele_x)
c_matrix_RMesh(:,i) = c_matrix_interp(RMesh_ele_y,RMesh_ele_x)
c_matrix_RBedR(:,i) = c_matrix_interp(RBedR_ele_y,RBedR_ele_x)
end
%reservoir side
Rho_matrix_RSide = inp.rhow0 + inp.drwdu.*c_matrix_RSide
%reservoir bed left of deep pool
Rho_matrix_RBedL = inp.rhow0 + inp.drwdu.*c_matrix_RBedL
%reservoir bed and deep pool left interaction point
Rho_matrix_LMesh = inp.rhow0 + inp.drwdu.*c_matrix_LMesh
%reservoir  deep pool left
Rho_matrix_DPL = inp.rhow0 + inp.drwdu.*c_matrix_DPL
%reservoir  deep pool bed
Rho_matrix_DPB = inp.rhow0 + inp.drwdu.*c_matrix_DPB
%reservoir  deep pool right
Rho_matrix_DPR = inp.rhow0 + inp.drwdu.*c_matrix_DPR
%reservoir bed and deep pool right interaction point
Rho_matrix_RMesh = inp.rhow0 + inp.drwdu.*c_matrix_RMesh
%reservoir bed right of deep pool
Rho_matrix_RBedR = inp.rhow0 + inp.drwdu.*c_matrix_RBedR
% Calculation and output solute flux (element central) :
Soulte_flux_RSide = Water_flux_RSide.*c_matrix_RSide.*Rho_matrix_RSide
Soulte_flux_RBedL = Water_flux_RBedL.*c_matrix_RBedL.*Rho_matrix_RBedL
Soulte_flux_LMesh = Water_flux_LMesh.*c_matrix_LMesh.*Rho_matrix_LMesh
Soulte_flux_DPL = Water_flux_DPL.*c_matrix_DPL.*Rho_matrix_DPL
Soulte_flux_DPB = Water_flux_DPB.*c_matrix_DPB.*Rho_matrix_DPB
Soulte_flux_DPR = Water_flux_DPR.*c_matrix_DPR.*Rho_matrix_DPR
Soulte_flux_RMesh = Water_flux_RMesh.*c_matrix_RMesh.*Rho_matrix_RMesh
Soulte_flux_RBedR = Water_flux_RBedR.*c_matrix_RBedR.*Rho_matrix_RBedR
% Combined and output solute flux (element central) :
Soulte_flux = cat (1,Soulte_flux_RSide,Soulte_flux_RBedL,Soulte_flux_LMesh + sum(Soulte_flux_DPL)...
    ,Soulte_flux_DPB,sum(Soulte_flux_DPR)+Soulte_flux_RMesh,Soulte_flux_RBedR )
% Calculation of total soulte flux through interface :
D3L1_Soulte_sum_interface = sum(Soulte_flux,2)/Time_range_max
D3L1_Soulte_sum_time = sum(Soulte_flux,1)
save('D3L1_Soulte_sum_interface','D3L1_Soulte_sum_interface')
save('D3L1_Soulte_sum_time','D3L1_Soulte_sum_time')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Calculation and output Inflow and Outflow of water volume and solute
%%%%% mass
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:length(D3L1_Waterflux_sum_interface)
    for j = Time_range
        if Water_flux(i,j)>0
water_flux_inflow(i,j) = Water_flux(i,j)
        elseif Water_flux(i,j)<=0
water_flux_inflow(i,j) = 0 
        end
    end
end
for i = 1:length(D3L1_Waterflux_sum_interface)
    for j = Time_range
        if Water_flux(i,j)>0
water_flux_outflow(i,j) = 0
        elseif Water_flux(i,j)<=0
water_flux_outflow(i,j) = Water_flux(i,j) 
        end
    end
end
inflow_Water_interface_1 = sum(water_flux_inflow,2)/(Time_range_max*inp.z)
inflow_Water_sum_time = sum(water_flux_inflow,1)
inflow_Water_sum_total = sum (inflow_Water_sum_time)
inflow_Water_interface_2 = zeros (34,1)%Create zero matrix for upper boundary
D3L1_inflow_Water_interface = cat(1,inflow_Water_interface_2,inflow_Water_interface_1)
outflow_Water_interface_1 = sum(water_flux_outflow,2)/(Time_range_max*inp.z)
outflow_Water_sum_time = sum(water_flux_outflow,1)
outflow_Water_sum_total = sum (outflow_Water_sum_time)
outflow_Water_interface_2 =  zeros (34,1)%Create zero matrix for upper boundary
D3L1_outflow_Water_interface = cat(1,outflow_Water_interface_2,outflow_Water_interface_1)
save('D3L1_inflow_Water_interface','D3L1_inflow_Water_interface')
save('D3L1_outflow_Water_interface','D3L1_outflow_Water_interface')
%%plot inflow and outflow of interface of water
figure
h = plot (x,D3L1_inflow_Water_interface,'-b','LineWidth',3.5)
hold on
h = plot (x,D3L1_outflow_Water_interface,'-R','LineWidth',3.5)
hold on
h = plot (x,A0,'-K')
min_x = 0.0;
max_x = 2.0;
xlabel('x (m)','fontname','times new roman','fontsize',13);
ylabel('Discharge(m^2s^-1)','fontname','times new roman','fontsize',13);
set(gca,'fontname','times new roman','fontsize',13);
axis([1.4 3.4 -3e-5 3e-5])
%set(gca,'YTick',[-1.5e-8:3e-9:1.5e-8],'fontname','times new roman','fontsize',13);
%set(gca,'YTickLabel',{'0.7','0.35','0.0'});
set(gca,'XTick',[1.4:0.1:3.4],'fontname','times new roman','fontsize',13);
%set(gca,'XTickLabel',{'1.3','1.2','1.1','1.0','0.9','0.8','0.7','0.6','0.5','0.4','0.3','0.2','0.1','0.0'});
set(gca,'yaxislocation','left');
grid on
%
for i = 1:75
    for j = Time_range
        if Soulte_flux(i,j)>0
            Solute_flux_inflow(i,j) = Soulte_flux(i,j)
        elseif Soulte_flux(i,j)<=0
            Solute_flux_inflow(i,j) = 0 
        end
    end
end
for i = 1:75
    for j = Time_range
        if Soulte_flux(i,j)>0
Solute_flux_outflow(i,j) = 0
        elseif Soulte_flux(i,j)<=0
Solute_flux_outflow(i,j) = Soulte_flux(i,j) 
        end
    end
end
inflow_Solute_interface_1 = sum(Solute_flux_inflow,2)/(Time_range_max*Thickness)
inflow_Solute_sum_time = sum(Solute_flux_inflow,1)
inflow_Solute_sum_total = sum (inflow_Solute_sum_time)
inflow_Solute_interface_2 = zeros (34,1)%Create zero matrix for upper boundary
D3L1_inflow_Solute_interface = cat(1,inflow_Solute_interface_2,inflow_Solute_interface_1)
outflow_Solute_interface_1 = sum(Solute_flux_outflow,2)/(Time_range_max*Thickness)
outflow_Solute_sum_time = sum(Solute_flux_outflow,1)
outflow_Solute_sum_total = sum (outflow_Solute_sum_time)
outflow_Solute_interface_2 =  zeros (34,1)%Create zero matrix for upper boundary
D3L1_outflow_Solute_interface = cat(1,outflow_Solute_interface_2 ,outflow_Solute_interface_1)
%%plot inflow and outflow of soulte interface
figure
h = plot (x,D3L1_outflow_Solute_interface,'-b','LineWidth',3.5)
hold on
h = plot (x,D3L1_inflow_Solute_interface,'-R','LineWidth',3.5)
hold on
h = plot (x,A0,'-K')
min_x = 0.0;
max_x = 2.0;
xlabel('x (m)','fontname','times new roman','fontsize',13);
ylabel('Discharge(m^2s^-1)','fontname','times new roman','fontsize',13);
set(gca,'fontname','times new roman','fontsize',13);
axis([1.4 3.4 -3e-5 3e-5])
%set(gca,'YTick',[-1.5e-8:3e-9:1.5e-8],'fontname','times new roman','fontsize',13);
%set(gca,'YTickLabel',{'0.7','0.35','0.0'});
set(gca,'XTick',[1.4:0.1:3.4],'fontname','times new roman','fontsize',13);
%set(gca,'XTickLabel',{'1.3','1.2','1.1','1.0','0.9','0.8','0.7','0.6','0.5','0.4','0.3','0.2','0.1','0.0'});
set(gca,'yaxislocation','left');
grid on
save('D3L1_inflow_Solute_interface','D3L1_inflow_Solute_interface')
save('D3L1_outflow_Solute_interface','D3L1_outflow_Solute_interface')
%% 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%Sensitivity analysis of solute mass %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nod  = readNOD(fil.basename);
ele  = readELE(fil.basename);
Time_step_range = 1:134
%Make x and y matrix (nodes)
x_matrix=reshape(nod(1).terms{xnod_idx},[inp.nn1,inp.nn2]);
y_matrix=reshape(nod(1).terms{ynod_idx},[inp.nn1,inp.nn2]);
% Make x and y matrix (elements)
xele_matrix=reshape(ele(1).terms{xele_idx},[inp.nn1-1,inp.nn2-1]);
yele_matrix=reshape(ele(1).terms{yele_idx},[inp.nn1-1,inp.nn2-1]);
%Get the Concentration and velocity data
%Get out of the velocity of the reservoir water 
A_Find_dat = textread('E:\SUTRAÄ£Äâ\DP_final\Normal\Find_D3L1.dat');
A_HydrulicConducitivy_dat = A_Find_dat(:,3)
%Find the index of reservoir node and element 
High_K = 3.5e-07
High_K_Selected = High_K/10
High_K_Reservoir = 3.51e-07;
High_K_DP = 3.52e-07;
ReservoirWater_indx = find(A_HydrulicConducitivy_dat>High_K...
    &A_HydrulicConducitivy_dat<=High_K_Reservoir);
DPWater_indx = find(A_HydrulicConducitivy_dat>High_K_Reservoir...
    &A_HydrulicConducitivy_dat<=High_K_DP);
%Paremeter for aquifer and reservoir
c_matrix_ReservoirWater = zeros(length(ReservoirWater_indx),1);
c_matrix_DPWater = zeros(length(DPWater_indx),1);
%mesh area and voulme
Area_reservoir = 2.35714e-5;
Area_DP = 2.5e-5;
Volume_reservoir = Area_reservoir*inp.z;
Volume_DP = Area_DP*inp.z;
%%%%%%%%%%%%
%Get the salinity (KG_Salt/KG_Water)
%%%%%%%%%%%%
for i = Time_step_range
c_matrixi = reshape(nod(i).terms{c_idx},[inp.nn1,inp.nn2]); % Initial concentration
C_interp = interp2(c_matrixi,2,'liner');
c_matrix_interp = C_interp(4:4:561,4:4:1921)%interp 2 times
c_elecentral = reshape(c_matrix_interp,[inp.ne,1]);
%Reservoir
c_matrix_ReservoirWater(:,i) = c_elecentral(ReservoirWater_indx);
c_matrix_DPWater(:,i) = c_elecentral(DPWater_indx);
end
%%%%%%%%%%%%
%Get the Density
%%%%%%%%%%%%
%Reservoir
Rho_reservoir = inp.rhow0 + inp.drwdu.*c_matrix_ReservoirWater
Rho_DP = inp.rhow0 + inp.drwdu.*c_matrix_DPWater
%%%%%%%%%%%%
% Calculation and output Slat Mass (element central) :
%%%%%%%%%%%%
%Reservoir
Salt_mass_reservoir = c_matrix_ReservoirWater.*Rho_reservoir.*Volume_reservoir.*1
Salt_mass_DP = c_matrix_DPWater.*Rho_DP.*Volume_DP.*1
Salt_mass_total = cat (1,Salt_mass_reservoir,Salt_mass_DP)
%Plot Total Soulte mass 
D3L1_Solute_total = sum(Salt_mass_total,1)
plot (D3L1_Solute_total)
save('D3L1_Solute_total','D3L1_Solute_total')




