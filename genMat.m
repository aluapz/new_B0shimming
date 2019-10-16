function [A, B] = genMat(handles)

%Shimorder
order = handles.order; 
if order == 1
    ns = 4;  % number of Shimcoils +1
elseif order == 2
    ns = 9; % number of Shimcoils +1
elseif order == 3
    ns = 13; % number of Shimcoils +1
end

%Load B0 Map/Magnitude Image
B0map = handles.data.B0map; 
Magn = handles.data.Magn; 

%Load Mask 
mask = handles.data.mask; 

%Resolution in x and y direction
deltai = handles.data.deltai;
deltaj = handles.data.deltaj;

%Bedeutung dieser Parameter??
szz = handles.data.szz;
xz = handles.data.xz;
yz = handles.data.yz; 
sx = handles.data.sx;
yx = handles.data.yx;
xx = handles.data.xx; 
xy = handles.data.xy;
yy = handles.data.yy;
sy = handles.data.sy; 

%% Fill the A and B matrix
counter = 1;
for n = 1: size(B0map,3)
    sz = szz(n);
    [r,c] = meshgrid(1:size(B0map,1), 1:size(B0map,2));
    r = reshape(r,[1,size(B0map,1)*size(B0map,2)]);
    c = reshape(c,[1,size(B0map,1)*size(B0map,2)]);
    r((mask(:,:,n)~=1))=[];
    c((mask(:,:,n)~=1))=[];
   
    coord = [xx*deltai,yx*deltaj,0,sx;xy*deltai,yy*deltaj,0,sy;xz*deltai,yz*deltaj,0,sz;0,0,0,1]*[r;c;zeros(1,length(r));ones(1,length(r))];
    xa = coord(1,:)*10^-3;
    y = -coord(2,:)*10^-3;
    z= -coord(3,:)*10^-3;
    
    % Calculation of A matrix --> size: (Number of Voxels) x (Number of spherical Harmonics used to approximate shim fields) 
    for sph = 1:49 %Number of spherical Harmonics to be used
        A(counter:counter+length(r)-1,sph) = kbase(sph,[xa; y ;z]'); %Calculate Spherical Harmonics 
    end

    sliceB0 = B0map(:,:,n)';
    B(counter:counter+length(r)-1) = (sliceB0((mask(:,:,n)==1)));
    counter= counter + length(r);
end

if( isempty( B ) )
    errordlg('Voxel falls outside of the FOV, make sure you entered the position correctly');
    SuccessFlag = 0;
    return;
end

B = B'; 
