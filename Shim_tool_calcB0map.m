function [handles,Magn] = Shim_tool_calcB0map(ReconObject, handles)

image =ReconObject.imageData; 
img_TE1= image(:,:,:,1);
img_TE2= image(:,:,:,2);
Magn = abs(img_TE1); 

patient_pos = ReconObject.dicomHeader.PatientPosition; 

Magn = permute(Magn,[2 1 3]); 
if strcmp(patient_pos,'HFS')
    Magn = flip(Magn,1); 
    Magn = flip(Magn,2); 
    Magn = flip(Magn,3); 
else
    Magn = flip(Magn,2);
end


%% Calculation of B0 Map

%Echo time difference:
TE1 = ReconObject.reconParams.EchoTimes(1);% in ms 
TE2 = ReconObject.reconParams.EchoTimes(2);% in ms 
deltaTE = (TE2-TE1)/1000; %in s

%Get Nucleus Type: 
nucleus = ReconObject.dicomHeader.ImagedNucleus;
if strcmp(nucleus,'23') %23Na
    gamma = 7.080816e7/2/pi;
else
    gamma = 26.7522208e7/2/pi;
end

% if (get(handles.radiobutton_newB0map_calc,'Value') == 0)
    % Unwrap Phase Images
    unwrapped_img_TE1 =sunwrap(img_TE1);  %sunwrap--> input: complex image, output: unwrapped phase image in rad
    unwrapped_img_TE2 =sunwrap(img_TE2);

    %Calculate Offresonancese
    PhaseDifference = unwrapped_img_TE2 -unwrapped_img_TE1;
    Offresonance_map = PhaseDifference./(deltaTE); %Offresonance Map in rad/s
    Offresonance_map = -Offresonance_map/2/pi; %Offresonance Map in Hz

    B0map= Offresonance_map/gamma; %divide by gyromagnetic ratio of sodium (MHz/T)

    B0map = permute(B0map,[2 1 3]);

    if strcmp(patient_pos,'HFS')
        B0map = flip(B0map,1);
        B0map = flip(B0map,2); 
        B0map = flip(B0map,3); 
    else
        B0map = flip(B0map,2); 
    end
%     else
%     % Calculation of B0 map with atan method 
% 
%     %mask for phase unwrapping 
%     Threshold = 0.1;
%     mysize = size(Magn); 
%     slice_start = 1;
%     slice_stop = mysize(3);
% 
%     Mask = zeros(mysize);  
% 
%     for n = slice_start:slice_stop
%         Magn_max = max(Magn(:));
%         Magn_norm = Magn(:,:,n)/Magn_max;
%         mask_slice = zeros(size(Magn,1),size(Magn,2)); 
%         mask_slice(Magn_norm> Threshold) = 1; 
%         %Fill mask:
%         for i = 1:mysize(2)
%             left_bound = find(mask_slice(:,i) == 1, 1 );
%             right_bound = find(mask_slice(:,i) == 1, 1, 'last' );
%             if (~isempty(left_bound)&&~isempty(right_bound))
%                 mask_slice(left_bound:right_bound,i) = 1; 
%             end
%         end
%         Mask(:,:,n) = mask_slice;
%     end
% 
%     PhaseDifference  = atan2(imag(img_TE1.*conj(img_TE2)),real(img_TE1.*conj(img_TE2)));
%     PhaseDifference = permute(PhaseDifference ,[2 1 3]); 
%     if strcmp(patient_pos,'HFS')
%         PhaseDifference = flip(PhaseDifference ,1); 
%         PhaseDifference = flip(PhaseDifference ,2); 
%         PhaseDifference = flip(PhaseDifference ,3); 
%     else
%         PhaseDifference = flip(PhaseDifference ,2); 
%     end
% 
%     PhaseDifference_unwrapped = laplacianUnwrap(PhaseDifference, Mask);
%     Offresonance_map  = (PhaseDifference_unwrapped)/(deltaTE); %Offresonance Map in rad/s
%     Offresonance_map = Offresonance_map /2/pi;
%     B0map = Offresonance_map/gamma; %B0 map in ppm
% end

%% Get Reconstruction Parameters:
if strcmp(ReconObject.reconParams.SamplingMode,'Radial') %isotropic acquisition
    deltai = ReconObject.reconParams.Resolution; %Resolution in x and y direction
    deltaj = ReconObject.reconParams.Resolution;
else
    deltai = ReconObject.reconParams.Resolution/ReconObject.reconParams.Scalx; %Resolution in x and y direction
    deltaj = ReconObject.reconParams.Resolution/ReconObject.reconParams.Scaly;
end 

%Image orientation (from reconObject.ImageOrientation):
xx = ReconObject.dicomHeader.ImageOrientationPatient(1);
xy = ReconObject.dicomHeader.ImageOrientationPatient(2);
xz = ReconObject.dicomHeader.ImageOrientationPatient(3);
yx = ReconObject.dicomHeader.ImageOrientationPatient(4);
yy = ReconObject.dicomHeader.ImageOrientationPatient(5);
yz = ReconObject.dicomHeader.ImageOrientationPatient(6);

%Image position --> Always Isocenter for Sodium Images: 
if strcmp(ReconObject.reconParams.SamplingMode,'Radial') %isotropic acquisition
    sx = -ReconObject.reconParams.Size*deltai/2; %1/2*(FOV in x-direction)
    sy = sx;
    FOVz = -sx;
%     szz = linspace(-FOVz/2,FOVz/2,size(B0map,3)); %Array of slice positions in z-direction
    szz = linspace(-FOVz+deltai/2,FOVz-deltai/2,size(B0map,3)); %Array of slice positions in z-direction
else
    sx = -ReconObject.reconParams.SizeX*deltai/2; %1/2*(FOV in x-direction)
    sy = -ReconObject.reconParams.SizeY*deltaj/2; %1/2*(FOV in y-direction)
    deltaz = ReconObject.reconParams.Resolution/ReconObject.reconParams.Scalz;
    FOVz = -ReconObject.reconParams.SizeZ*deltaz;
    szz = linspace(-FOVz+deltaz/2,FOVz-deltaz/2,size(B0map,3)); %Array of slice positions in z-direction
end

currShim = ReconObject.dicomHeader.Shim; 
setappdata(0,'CurrShimValues', currShim); 

handles.data = struct ( 'B0map' , B0map, 'szz' , szz , 'Magn', Magn,...
        'deltaTE', deltaTE, 'deltai' , deltai, 'deltaj', deltaj , 'sy', ...
        sy, 'sx', sx , 'yz',  yz, 'yy',  yy, 'yx',  yx, 'xz',  xz, 'xy',...
        xy , 'xx',  xx );
    
%Set Mask Data -> Empty
% if get(handles.radiobutton_mask_fix,'Value') == 0
    handles.data.mask = [];
    handles.data.mask_contour = [];
% else
%     handles.data.mask = mask; 
%     handles.data.mask_contour = mask_contour;
% end   

%Set Patient Position
handles.data.patient_pos = ReconObject.dicomHeader.PatientPosition; 
