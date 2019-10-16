pathName = uigetdir( [], 'Please select the folder containing the DICOM files' );
if ( pathName ~= 0 )
    listing = dir( pathName );
    h = waitbar( 0, 'Loading files...' );
    for f = 1 : length( listing )
        waitbar (f / length( listing ) )
        fileName = listing( f ).name;
        [~, ~, ext] = fileparts( fileName );
        if( strcmp( ext , '.IMA' ) )
            obj = read_dicom_header_local( strcat( pathName, '\', fileName ) );
            if ( strcmp( obj.acqname( end-4 ), 'P' ) ) %--> search for phase images
                slicenum = obj.ima;
                B0map( :, :, slicenum ) = obj.pix;
                szz( slicenum ) =  obj.pos(3); %--> slice position??
                deltaTE= abs( obj.TE - obj.specTE / 1000 ) ; %in msec
                xx = obj.norm(1); %--> Image orientation?? 
                xy = obj.norm(2);
                xz = obj.norm(3);
                yx = obj.norm(4);
                yy = obj.norm(5);
                yz = obj.norm(6);
                sx = obj.pos(1);
                sy = obj.pos(2);
                deltai = obj.PhaseFoV / size( B0map, 1 ); %Resolution in mm
                deltaj = obj.ReadoutFoV / size( B0map, 1 ); %Resolution in mm
            elseif ( strcmp( obj.acqname( end-4 ), 'M' ) ) %--> search for magnitude images
                slicenum = obj.ima;
                Magn( :, :, slicenum ) = obj.pix;
            end
        end
    end
    close( h );
    if ( ~exist( 'B0map', 'var' ) || size( B0map, 3 ) ~= obj.nslice || size( B0map, 3 ) == 0 )
        errordlg('Phase maps are not copied properly from the scanner or wrong folder was selected! try again');
        return;
    elseif ( ~exist( 'Magn', 'var' ) || size(Magn,3) ~= obj.nslice || size( Magn,3 ) == 0 )
        errordlg('Magn images are not copied properly from the scanner or wrong folder was selected!try again');
        return;
    end
    handles.data = struct ( 'B0map' , B0map, 'szz' , szz , 'Magn', Magn,...
        'deltaTE', deltaTE, 'deltai' , deltai, 'deltaj', deltaj , 'sy', ...
        sy, 'sx', sx , 'yz',  yz, 'yy',  yy, 'yx',  yx, 'xz',  xz, 'xy',...
        xy , 'xx',  xx );
    guidata( hObject, handles );
    axes( handles.axes1 );cla;
    imagesc( abs ( Magn( :, :, 1)' ) );
    axis off;
    colormap gray;
    axes( handles.axes2);cla;
    imagesc( flip( abs ( squeeze( Magn( :, end/2 , :) )'  ) ,1 ) );
    axis off;
    colormap gray;
    axes( handles.axes3 );cla;
    imagesc( flip(abs ( squeeze( Magn( end/2, : , :) )' ) ,1 ) );
    axis off;
    colormap gray;
    set(handles.slice, 'Min', 1, 'Value', 1 ,'Max', obj.nslice ,  'SliderStep' , [1 / obj.nslice 1 / obj.nslice]);
    set(handles.SliceCor, 'Min', 1, 'Value', size(Magn,2) /2 ,'Max', size(Magn,2) ,  'SliderStep' , [1 / size(Magn,2) 1 / size(Magn,2)]);
    set(handles.SliceSag, 'Min', 1, 'Value', size(Magn,1)/2 ,'Max', size(Magn,1) ,  'SliderStep' , [1 / size(Magn,1) 1 / size(Magn,1)]);
end