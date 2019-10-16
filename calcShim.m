function Vals = calcShim(A,B,handles)

order = handles.order; 
if order == 1
    ns = 4;  % number of Shimcoils +1 (0th order)
elseif order == 2
    ns = 9; % number of Shimcoils +1
elseif order == 3
    ns = 13; % number of Shimcoils +1
end

%Always use coefficient matrix
load('W:\radiologie\data\MR-Physik\Mitarbeiter\Zeiger, Paula\Shim_tool_Terra\coeff_hfs.mat');
% load('C:\MATLAB\B0_Shimming\Shim_tool\coeff_outlier_excluded.mat'); 
coeffsize = size(coeff,1); 
coeff1st = zeros(coeffsize,3);
coeff1st(2:4,1:3) = eye(3,3);
% % f0 coefficients
coeff0th = zeros(coeffsize,1);
coeff0th(1,1) = 1;
% % coeff matrix
coeff = [coeff0th coeff1st coeff];
Anew = A(:,1:coeffsize) *  coeff;

% Get current Shim Values: 
[~,Shim_info]=system('AdjValidate.exe -shim -get -mp'); %adjust validate: Siemens WIP --> communicates with adjustment settings
pos = strfind(Shim_info,'Thread'); 
Shim_info = Shim_info(pos+8:end);
Shim_info = strsplit(Shim_info); 
Currentshim = zeros(12,1);
if isempty(Shim_info{end})
    Currentshim = [-727.87 -875.73 -809.23 -107.83 40.06 -48.79 -35.11 -12.77 -499.61 -7.01 305.55 -323.77]; %Shimvalues VE12U_20181126 %xyz (A11,B11,A10) z2 (A20) zx (A21) zy (B21) c (A22) s (B22)
else
    for n=1:12
        Currentshim(n) = str2num(cell2mat(Shim_info(n+1)));
    end
    Currentshim = Currentshim'; 
    if Currentshim(1) > 0
         Currentshim(1) = -Currentshim(1);
    end
end
t = [ Currentshim(3) Currentshim(1) Currentshim(2) Currentshim( 4 : end )]; %Sort to A10 - A11 - B11 ...

%Upper and lower limits for Shim Values @ 7 T (Terra system) (µT/m^n)
constraintsu = [ 3000 3000 3000 9360 4680 4620 4620 4560 15232 14016 14016 14016] - abs(t); % zyx z2 zx zy c s
constraintsl = [ -3000 -3000 -3000 -9360 -4680 -4620 -4620 -4560 -15232 -14016 -14016 -14016] + abs(t); % zyx z2 zx zy c s

% Shimming
x = (pinv( Anew )* B * 1e6)';
shimValsToapply = -x';
vals = shimValsToapply( 1 : ns ); % vals (uT/m^n)
%Check if constraints are fulfilled
if( sum( ( vals( 2 : ns )') < constraintsl(1:ns-1) ) ~= 0 || sum( ( vals( 2 : ns )') > constraintsu(1:ns-1)  ) ~= 0)
    svds = svd( Anew ); %if constraints are not fullfilled, truncate smallest singular value of A-Matrix 
    for sss = length( svds ): -1 : 1
        x = ( pinv( Anew, svds( sss ) ) * B * 1e6)'; % svds(ss) specifies a value for the tolerance --> pinv treats singular values of A that are smaller than the tolerance as zero.
        shimValsToapply = -x';
        vals = shimValsToapply( 1 : ns ); % vals (uT/m^n)
        if( sum( ( vals( 2 : ns )' ) < constraintsl(1:ns-1)  ) == 0 && sum( ( vals( 2 : ns )' ) > constraintsu(1:ns-1)  ) == 0 )
            break;
        end
    end
end
format bank
Vals = [shimValsToapply(3)  shimValsToapply(4) shimValsToapply(2) shimValsToapply(5:ns)']'; %uT/m correct order corresponding to 3D Shim order (A11,B11,A10,...)

%Add current shim values
t = [t(2) t(3) t(1) t(4:end)];
Vals = Vals + t(1:ns-1)';

Shim_string = strcat('AdjValidate.exe -shim -set -mp',32,num2str(Vals')); 
system(Shim_string) 



