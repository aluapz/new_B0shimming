
% ================================================================================
function v=get_dicom_value(fid,VR, length)
% ================================================================================
%fprintf('VR: %s, length: %d\n', VR,length);
%keyboard
switch VR
    %    case {'LT','UI','AS','DT','TM','ST'}
    case {'UI','AS','DT','ST'}
        %ftell(fid)
        %v=char(fread(fid,length,'char')');
        v=fread(fid,length,'uchar');
    case {'CS','LO','SH','PN','DA','LT','TM'}
        v=char(fread(fid,length,'uchar')');
    case {'IS','DS'}
        %    	v=str2num(fread(fid,length,'uchar'));
        v=char(fread(fid,length,'uchar')');
        %disp(['DS: ' v])
        v=str2num(strrep(v, '\',' '));
        %    	v=str2num(char(fread(fid,length,'uchar')'));
    case 'SS',
        %    	v=fread(fid,1,'int16');
        v=fread(fid,length/2,'int16');
        if length ~= 2
            %fprintf('  ----> !!! unsigned short mit %d byte', length);
            %fseek(fid, length-2,'cof');
        end
    case 'US',
        %    	v=fread(fid,1,'uint16');
        v=fread(fid,length/2,'uint16');
        if length ~= 2
            %fprintf('  ----> !!! unsigned short mit %d byte', length);
            %fseek(fid, length-2,'cof');
        end
    case 'UL',
        %    	v=fread(fid,1,'uint32');
        v=fread(fid,length/4,'uint32');
        if length ~= 4
            %fprintf('  ----> !!! unsigned long mit %d byte', length);
            %fseek(fid, length-4,'cof');
        end
    case 'FL',
        %    	v=fread(fid,1,'float32');
        v=fread(fid,length/4,'float32');
    case 'FD',
        %    	v=fread(fid,1,'float64');
        v=fread(fid,length/8,'float64');
    case 'OB',			% other byte string
        fseek(fid, length,'cof');
        v=['OB Field (length ' num2str(length) ' Bytes)'];
    case {'SQ'}
        %v=char(fread(fid,length,'uchar')');
        v=fread(fid,length,'uchar')';
        %fseek(fid, length,'cof');
        %v=['SQ Field (length ' num2str(length) ' Bytes)'];
    otherwise,
        fseek(fid, length,'cof');
        v=-1;
end