function calcMask_autosegment_fill(handles , hObject)
Magn = handles.data.Magn; 
datasize = size(Magn);
mask = zeros((datasize));
thres = get(handles.slider_threshold, 'Value'); 
slice_start = str2num(get(handles.slicerange_start,'String')); 
slice_stop = str2num(get(handles.slicerange_stop,'String')); 
Magn_max = max(Magn(:)); % maximum signal intensity

%Do thresholding 
if get(handles.radiobutton_fill, 'Value') == 0 %don't fill mask
    mask(Magn>=thres*Magn_max) = 1; 
    mask(:,:,1:slice_start-1) = 0; 
    mask(:,:,slice_stop+1:end) = 0;
else
    for n = slice_start:slice_stop
        Magn_max = max(Magn(:));
        Magn_norm = Magn(:,:,n)/Magn_max;
        mask_slice = zeros(size(Magn,1),size(Magn,2)); 
        mask_slice(Magn_norm> thres) = 1; 
        %Fill mask:
        for i = 1:datasize(2)
            left_bound = find(mask_slice(:,i) == 1, 1 );
            right_bound = find(mask_slice(:,i) == 1, 1, 'last' );
            if (~isempty(left_bound)&&~isempty(right_bound))
                mask_slice(left_bound:right_bound,i) = 1; 
            end
        end
        mask(:,:,n) = mask_slice;
    end
end

handles.data.mask = mask;
guidata(hObject, handles);

%Show Image
showimages(handles); %Plot images

%Assign to Workspace
assignin('base','Mask',mask); 

    



