fil=readFIL();
%inp  = inpObj(fil.basename); %read inp file
inp  = inpObj(fil.basename,'block_reading','yes'); % this may be faster if inp file is too slow to parse
inp.get_x_nod_mtx; % this creates a inp.x_nod_mtx, which is x coordinates in matrix form
inp.get_y_nod_mtx;
inp.get_dx_cell_mtx; %this creates variable inp.x_cell_mtx, which is the length of each cell
inp.get_dy_cell_mtx; %this creates variable inp.y_cell_mtx, which is the height of each cell
nod  = readNOD(fil.basename); %read nod file
% one could also do:
%[nod,nod2]  = readNOD( name,'outputnumber',3,'outputfrom',10);
%the reading starting from the 3rd outputs and only reads up to 13th output
ele  = readELE(fil.basename);

