function showimages(handles)

Magn = handles.data.Magn;

%Transversal: 
axes( handles.axes1 );
cla;
imshow(abs ( Magn( :, :, int32(get(handles.Slice,'Value')))' ),'InitialMagnification','fit')
% imagesc(abs ( Magn( :, :, int32(get(handles.Slice,'Value')))' )) 
E = abs ( Magn( :, :, int32(get(handles.Slice,'Value')))' );
if ( ~isempty (handles.data.mask) )
    hold all
    if ( ~isempty(handles.data.mask_contour) )
        xi = handles.data.mask_contour(:,1);
        yi = handles.data.mask_contour(:,2);
        line(xi,yi,'LineWidth',2,'Color','green');
    else
        green = cat(3, zeros(size(E)), ones(size(E)), zeros(size(E)));
        h = imshow(green, 'InitialMagnification', 'fit');
        set(h, 'AlphaData', handles.data.mask( : , : , int32( get( handles.Slice, 'Value' ) ) )' );
    end
end
caxis( [ min( E(:) ), max( E(:) ) ] );


%Sagittal: 
axes(handles.axes3);
cla;
imshow(flip( abs ( squeeze( Magn( int32( get( handles.SliceSag, 'Value' ) ),: , :) )'  ) ,1 ))
axis square;hold all
E = flip( abs ( squeeze( Magn( int32( get( handles.SliceSag, 'Value' ) ),: , :) )'  ) ,1 );
if ( ~isempty (handles.data.mask) )
    if (isempty(handles.data.mask_contour) )
        green = cat(3, zeros(size(E)), ones(size(E)), zeros(size(E)));
        h = imshow(green); axis square;
        set(h, 'AlphaData',flip(squeeze(handles.data.mask(int32( get( handles.SliceSag, 'Value' ) ),:,:))',1));
    end
end
caxis([min(E(:)) max(E(:))]);

%Coronal: 
axes(handles.axes2);
cla;
imshow(flip( abs ( squeeze( Magn( :, int32( get( handles.SliceCor, 'Value' ) ) , :) )'  ) ,1 ))
axis square;
E = flip( abs ( squeeze( Magn( :,int32( get( handles.SliceCor, 'Value' ) ) , :) )'  ) ,1 );
if ( ~isempty (handles.data.mask) )
    if (isempty(handles.data.mask_contour) )
        hold all
        green = cat(3, zeros(size(E)), ones(size(E)), zeros(size(E)));
        h = imshow(green); 
        axis square;
        set(h, 'AlphaData',flip(squeeze(handles.data.mask(:,int32( get( handles.SliceCor, 'Value' ) ),:))',1));
    end
end
caxis([min(E(:)) max(E(:))]);