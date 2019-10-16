function SuccessFlag = calcMask_singlevoxel(handles , hObject)
SuccessFlag = 1;

voxelcenter = [str2double(get(handles.L,'String')) str2double(get(handles.A,'String')) str2double(get(handles.F,'String'))] *1e-3;
voxelsize = [str2double(get(handles.R2L,'String')) str2double(get(handles.A2P,'String')) str2double(get(handles.F2H,'String'))] * 1e-3;
rot = - str2double(get(handles.Rot,'String'));
T2C = str2double(get(handles.T2C,'String'));
T2S = - str2double(get(handles.T2S,'String'));
handles.order = get(handles.select_shimorder, 'Value'); %Shimorder -> determines number of Shimcoils to be used
Magn = handles.data.Magn;

%Resolution in x and y direction:
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

if ( sum( voxelsize > [0 0 0]) == 3)
    
    %Calculate Shimvolume
    p =[-voxelsize(1)/2 -voxelsize(2)/2 voxelsize(3)/2;-voxelsize(1)/2 -voxelsize(2)/2 -voxelsize(3)/2;-voxelsize(1)/2 voxelsize(2)/2 voxelsize(3)/2; -voxelsize(1)/2 voxelsize(2)/2 -voxelsize(3)/2; voxelsize(1)/2 -voxelsize(2)/2 -voxelsize(3)/2;voxelsize(1)/2 -voxelsize(2)/2 voxelsize(3)/2;voxelsize(1)/2 voxelsize(2)/2 -voxelsize(3)/2; voxelsize(1)/2 voxelsize(2)/2 voxelsize(3)/2];
    % 1. About the x-axis: T>C
    R1 = [1,0,0;0,cos(T2C),sin(T2C);0,-sin(T2C),cos(T2C)];
    % 2. About the y-axis: T>S
    R2 = [cos(T2S),0,-sin(T2S);0,1,0;sin(T2S),0,cos(T2S)];
    % 3. About the z-axis: inplane
    R3 = [cos(rot),sin(rot),0;-sin(rot),cos(rot),0;0,0,1];
    p = p * R1*R2*R3;
    for i = 1:8
        p(i,1:3) = p(i,1:3) +  voxelcenter;
    end
    l = voxelcenter - voxelsize/2;
    u = voxelcenter + voxelsize/2;
    
    counter = 1;
    for n = 1: size( Magn,3)  
        sz =  szz(n);
        [r,c] = meshgrid(1:size( Magn,1), 1:size( Magn,2));
        r = reshape(r,[1,size( Magn,1)*size( Magn,2)]);
        c = reshape(c,[1,size( Magn,1)*size( Magn,2)]);
        rr = ones(1,length(r));

        coord = [ xx* deltai, yx* deltaj,0, sx; xy* deltai, yy* deltaj,0, sy; xz* deltai, yz* deltaj,0,sz;0,0,0,1]*[r;c;zeros(1,length(r));ones(1,length(r))];
        xa = coord(1,:)*10^-3;
        y = -coord(2,:)*10^-3;
        z= -coord(3,:)*10^-3;

        %Calculation of Mask: 
        in = (inhull([xa' y' z'],p)); % Inhull: tests if a set of points are inside a convex hull
        xa(in~=1) = [];
        y(in~=1) = [];
        z(in~=1) = [];
        r(in~=1) = [];
        rr(in~=1) = 0;
        mm = zeros(size( Magn,1), size( Magn,2));
        mm((rr(:)==1)) = 1;
        mask(:,:,n) = mm;
        counter= counter + length(r);
    end

    mask = permute(mask,[2 1 3]);
    
    handles.data.mask = mask;

    %Chose Slider Positions
    %Transversal: Slice Position Isocenter
    Magn = handles.data.Magn;
    set(handles.Slice,'Value',size(Magn,3)/2);  
    set(handles.edit_CurrentSlice,'String',num2str(size(Magn,3)/2));
    guidata(hObject, handles);  
    
    %Coronal: first slice in which voxel is visible
    sliceNum = int32(get(handles.SliceCor,'Value'));
    for sm = 1 : size( mask, 2)
        if( sum ( sum( mask (:, sm, :) ) ) ~= 0)
            sliceNum = sm;
            break;
        end
    end
    set(handles.SliceCor,'Value',sm); 
   
    %Sagittal: first slice in which voxel is visible
    sliceNum = int32(get(handles.SliceSag,'Value'));
    for sm = 1 : size( mask, 1)
        if( sum ( sum( mask (sm, :, :) ) ) ~= 0)
            sliceNum = sm;
            break;
        end
    end
    set(handles.SliceSag,'Value',sm); %first slice in which voxel is visible

    %Plot Images
    showimages(handles); 
end
return;