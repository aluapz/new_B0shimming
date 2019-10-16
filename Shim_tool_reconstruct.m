function currReconObj = Shim_tool_reconstruct(params)

[params.data, MdhInfo]  = RadialRecon_ReadData_VE11(params);
params.Channels         = MdhInfo.NumOfChannels;
params.ChannelId        = MdhInfo.UsedChannels;


for ech = params.echo_start:params.echo_stop
        [result, params] = RadialRecon_GriddingReconstruction (squeeze(params.data(:,:,1, ech, 1)), params);
        params.Images(:,:,:,1,ech) = result;
        params.result (:,:,:,ech, 1) = result;
end


%% Export reconObject to workspace 
currReconObj = reconObject_VE11(params.filename,params.path);
currReconObj = currReconObj.setImageData(params.result(:,:,:,params.echo_start:params.echo_stop));
currReconObj = currReconObj.setReconParams(params);   
currReconObj = currReconObj.setDicomHeader(RadialRecon_DicomHeader(params));    

%% Save mat file  
reconObject_filename=strcat(currReconObj.pathname,'\',currReconObj.getVarName); 
saveToStruct(currReconObj, reconObject_filename); 
status(0);

%% Set reconObject to appdata

setappdata(0,'reconObject',currReconObj);

end 

%% LG: Save ReconObject without class definition 
function saveToStruct(obj,filename)
      varname = inputname(1);
      props = properties(obj);
      for p = 1:numel(props)
          s.(props{p})=obj.(props{p});
      end
      eval([varname ' = s'])
      save(filename, varname)
end