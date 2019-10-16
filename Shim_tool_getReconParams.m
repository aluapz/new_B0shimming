function params = Shim_tool_getReconParams(params,handles)

params.Acquisition = 'Standard'; 
switch params.SamplingMode
    case 'Radial'
        [kvec, dk, RES, ~] = RadialRecon_kvec_sim (params);
    case 'Quader'
        [kvec, dk, RES,~, ~, ~, Projections] = RadialRecon_kvec_Quader(params);
end

FOV = 240; %default recon FOV

switch params.SamplingMode
    case 'Quader'
            params.SizeX        = round(FOV/RES/params.Scalx);
            params.SizeY        = round(FOV/RES/params.Scaly);
            params.SizeZ        = round(FOV/RES/params.Scalz);
            params.FillingSizeY = params.SizeX;
            params.FillingSizeX = params.SizeY;
            params.FillingSizeZ = params.SizeZ;
    otherwise
            params.Size             = round(FOV/RES);
            params.FillingSize      = params.Size;
            params.FillingSizeZDir  = params.Size; 
end

params.ShiftX           = 0;
params.ShiftY           = 0;
params.ShiftZ           = 0;
params.RotX             = 0;
params.RotY             = 0;
params.RotZ             = 0;


%--- Filter settings
params.Filter           = 'Gaussian';     % set Gaussian Filter 
params.FilterParam      = 1e-3 * str2num(get(handles.edit_sigma, 'String'));


params.SliceDirection   = 1;                   % 1: transversal

switch params.SamplingMode
    case 'Quader'
        params.FillingSizeZDir = params.SizeZ;
end

%--- Width of Kaiser Bessel gridding window & oversampling
params.gridOS           = 2;
params.Width            = 4;

%--- Trajectory parameters
params.flExpTraj=false;
params.flExtTraj=false;

%--- Density Compensation
params.DensComp = 'pre';

%--- Projection Selection
params.ProjSel      = 0;
params.ProjLower    = 1;
params.ProjUpper    = params.Projections;

%--- Dummy Channel & Echo selection
params.dummy             = 0;
params.echosel           = 0;
params.echo_start  = 1;
params.echo_stop   = params.Echos;

%--- Average Selection
params.AvLower = 1;
params.AvUpper = 1;

%--- ReconMode
params.flReconMode = 'Standard'; 
params.noReplicas = 1; 

params.saveCalibrationData  = false; 
