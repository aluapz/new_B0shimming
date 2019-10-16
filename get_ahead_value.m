% ================================================================================
function v=get_ahead_value(ahead, field, out_flag)
% ================================================================================
%disp(field);
nposit=findstr(ahead,field);
v=[];
if ~isempty(nposit)
    for p=1:length(nposit)
        npos=nposit(p);
        lpos=findstr(ahead(npos:end),10);
        lpos=lpos(1);
        tmp_str=ahead(npos:npos+lpos-2);
        %		v=str2num(tmp_str(findstr(tmp_str,'=')+1:end));
        tmp_str=tmp_str(findstr(tmp_str,'=')+2:end);
        val=str2num(tmp_str);
        if isempty(val), v=tmp_str; else v(p)=val; end
        %if isempty(val), v{p}=tmp_str; else v{p}=val; end
        % switch field
        % case 'sSliceArray.lSize'
        % whos val v tmp_str
        % end
    end
end
if (out_flag > 0), fprintf('ahead: %s = %s\n',field,v); end

