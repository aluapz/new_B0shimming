% spherical_harmonics
% l degree
% m order
% coord is a column vector of coordinates (x,y,z)
% RSP defined as in Blanco et al. "Evaluation of the rotation matrices in the basis of real
% spherical harmonics"
function val = spha(l,m,coord,normalisation)
% if l>1
%     alpha = 0.5;
%     rotmax = [1 0 0; 0 cos(alpha) -sin(alpha);0 sin(alpha) cos(alpha)];
%     rotmay = [cos(alpha) 0 sin(alpha);0 1 0; -sin(alpha) 0 cos(alpha)];
%     rotmaz = [cos(alpha) -sin(alpha) 0;sin(alpha) cos(alpha) 0;0 0 1];
%     coord=coord*rotmax;
%     coord=coord*rotmay;
%     coord=coord*rotmaz;
% end
x = coord(:,1);
y = coord(:,2);
z = coord(:,3);
rho2 = (x.*x + y.*y);
rho4 = rho2.*rho2;
rho6 = rho4.*rho2;
rho8 = rho4.*rho4;
r = 1;
if normalisation
    r = sqrt(x.^2 + y.^2 + z.^2);
end
normalization = false;
switch(l)
    case 0
        val = ones(size(coord(:,1)));
        if normalization, nfac = sqrt(1/4/pi); val = val*nfac; end
    case 1
        switch(m)
            case 0                
                val = z./r;
                if normalization, nfac = sqrt(3/4/pi); val = val*nfac; end
            case 1                
                val = x./r;
                if normalization, nfac = sqrt(3/4/pi); val = val*nfac; end
            case -1
                val = y./r;
                if normalization, nfac = sqrt(3/4/pi); val = val*nfac; end
            otherwise
                error('order or degree of spherical harmonic does not exist');
        end
    case 2
        switch(m)
            case 0                
                val = ((z.^2 - (x.^2 + y.^2)/2))./r.^2;
                if normalization, nfac = sqrt(5/16/pi); val = val*nfac; end
            case 1                
                val = (x.*z)./r.^2;
                if normalization, nfac = sqrt(15/4/pi); val = val*nfac; end
            case -1               
                val = (z.*y)./r.^2;
                if normalization, nfac = sqrt(15/4/pi); val = val*nfac; end
            case 2                
                val = (x.^2 - y.^2)./r.^2;
                if normalization, nfac = sqrt(15/16/pi); val = val*nfac; end
            case -2
                val = (x.*y)./r.^2;
                if normalization, nfac = sqrt(15/4/pi); val = val*nfac; end
            otherwise
                error('order or degree of spherical harmonic does not exist');
        end
    case 3
        switch(m)
            case 0               
                val = (z.^3 - 3/2.*z.*(x.^2 + y.^2))./r.^3;
                if normalization, nfac = sqrt(7/16/pi); val = val*nfac; end
            case 1                
                val = ((z.^2 - 1/4*(x.^2 + y.^2)).*x)./r.^3;
                if normalization, nfac = sqrt(21/32/pi); val = val*nfac; end
            case -1               
                val = ((z.^2 - 1/4*(x.^2 + y.^2)).*y)./r.^3;
                if normalization, nfac = sqrt(21/32/pi); val = val*nfac; end
            case 2                
                val = (x.^2.*z - y.^2.*z)./r.^3;
                if normalization, nfac = sqrt(105/16/pi); val = val*nfac; end
            case -2                
                val = (x.*z.*y)./r.^3;
                if normalization, nfac = sqrt(105/4/pi); val = val*nfac; end
            case 3                
                val = (x.^3 - 3.*x.*y.^2)./r.^3;
                if normalization, nfac = sqrt(35/32/pi); val = val*nfac; end
            case -3               
                val = (3.*y.*x.^2 - y.^3)./r.^3;
                if normalization, nfac = sqrt(35/32/pi); val = val*nfac; end
            otherwise
                error('order or degree of spherical harmonic does not exist');
        end
    case 4
        switch(m)
            case 0                
                val = (z.*z.* (z.*z - 3*(y.^2 + x.^2)) + 3/8*(y.^2 + x.^2).^2)./r.^4;
                if normalization, nfac = sqrt(9/256/pi); val = val*nfac; end
            case 1           
                val = ((z.^2 - 3/4*(y.^2 + x.^2)) .*z.*x)./r.^4;
                if normalization, nfac = sqrt(45/32/pi); val = val*nfac; end
            case -1                
                val = ((z.^2 - 3/4*(y.^2 + x.^2)) .*z.*y)./r.^4;
                if normalization, nfac = sqrt(45/32/pi); val = val*nfac; end
            case 2              
                val = ((z.^2 - 1/6*(y.^2 + x.^2)) .*(x.*x - y.*y))./r.^4;
                if normalization, nfac = sqrt(45/64/pi); val = val*nfac; end
            case -2                
                val = ((z.^2 - 1/6*(y.^2 + x.^2)) .*x.*y)./r.^4;
                if normalization, nfac = sqrt(45/16/pi); val = val*nfac; end
            case 3               
                val = (z.*x .*(x.^2 - 3*y.^2))./r.^4;
                if normalization, nfac = sqrt(315/32/pi); val = val*nfac; end
            case -3              
                val = (z.*y .*(3*x.^2 - y.^2))./r.^4;
                if normalization, nfac = sqrt(315/32/pi); val = val*nfac; end
            case 4
                val = (y.^4 - 6*x.^2.*y.^2 + x.^4)./r.^4;
                if normalization, nfac = sqrt(315/256/pi); val = val*nfac; end
            case -4                
                val = (x.*y .* (x.^2 - y.^2))./r.^4;
                if normalization, nfac = sqrt(315/16/pi); val = val*nfac; end
            otherwise
                error('order or degree of spherical harmonic does not exist');
        end
    case 5
        if normalization, error 'normalization not implemented for 5th order',end
        switch(m)
            case 0
                val = (z.*(z.^4 - 5*z.^2.*(x.^2 + y.^2) + 15/8*(x.^2 + y.^2).^2))./r.^5;
            case 1
                val = (x.*(z.^4 - 3/2*z.^2.*(x.^2 + y.^2) + 1/8*(x.^2 + y.^2).^2))./r.^5;
            case -1
                val = (y.*(z.^4 - 3/2*z.^2.*(x.^2 + y.^2) + 1/8*(x.^2 + y.^2).^2))./r.^5;
            case 2
                val = (z.*(x.^2 - y.^2).*(z.^2 - 1/2.*(x.^2 + y.^2)))./r.^5;
            case -2
                val = (x.*y.*z.*(z.^2 - 1/2.*(x.^2 + y.^2)))./r.^5;
            case 3
                val = (x.*(x.^2 - 3*y.^2).*(z.^2 - 1/8*(x.^2 + y.^2)))./r.^5;
            case -3                
                val = (y.*(3*x.^2 - y.^2).*(z.^2 - 1/8*(x.^2 + y.^2)))./r.^5;
            case 4
                val = (z.*(x.^4 - 6*x.^2.*y.^2 + y.^4))./r.^5;
            case -4                
                val = (x.*y.*z.*(x.^2 - y.^2))./r.^5;
            case 5
                val = (x.*(x.^4 - 10*x.^2.*y.^2 + 5*y.^4))./r.^5;
            case -5                
                val = (y.*(y.^4 - 10*x.^2.*y.^2 + 5*x.^4))./r.^5;
            otherwise
                error('order or degree of spherical harmonic does not exist');
        end
    case 6
        if normalization, error 'normalization not implemented for 6th order',end
        switch(m)
            case 0
                val = (z.^6 - 15/2*z.^4.*(x.^2 + y.^2) + 45/8*z.^2.*(x.^2 + y.^2) - 5/16.*(x.^2 + y.^2).^3)./r.^6;
            case 1
                val = (z.*x.*(z.^4 - 5/2*z.^2.*(x.^2 + y.^2) + 5/8*(x.^2 + y.^2).^2))./r.^6;
            case -1
                val = (z.*y.*(z.^4 - 5/2*z.^2.*(x.^2 + y.^2) + 5/8*(x.^2 + y.^2).^2))./r.^6;
            case 2
                val = ((x.^2 - y.^2).*(z.^4 - z.^2.*(x.^2 + y.^2) + 1/16.*(x.^2 + y.^2).^2))./r.^6;
            case -2
                val = (x.*y.*(z.^4 - z.^2.*(x.^2 + y.^2) + 1/16.*(x.^2 + y.^2).^2))./r.^6;
            case 3
                val = (z.*x.*(x.^2 - 3*y.^2).*(z.^2 - 3/8*(x.^2 + y.^2)))./r.^6;
            case -3                
                val = (z.*y.*(3*x.^2 - y.^2).*(z.^2 - 3/8*(x.^2 + y.^2)))./r.^6;
            case 4
                val = ((z.^2 - 1/10*(x.^2 + y.^2)).*(x.^4 - 6*x.^2.*y.^2 + y.^4))./r.^6;
            case -4                
                val = (x.*y.*(x.^2 - y.^2).*(z.^2 - 1/10*(x.^2 + y.^2)))./r.^6;
            case 5
                val = (z.*x.*(x.^4 - 10*x.^2.*y.^2 + 5*y.^4))./r.^6;
            case -5
                val = (z.*y.*(y.^4 - 10*x.^2.*y.^2 + 5*x.^4))./r.^6;
            case 6
                val = ((x.^2 - y.^2).*(x.^4 - 14*x.^2.*y.^2 + y.^4))./r.^6;
            case -6
                val = (x.*y.*(x.^2 - 3*y.^2).*(3*x.^2 - y.^2))./r.^6;
            otherwise
                error('order or degree of spherical harmonic does not exist');
        end
    case 7
        if normalization, error 'normalization not implemented for 7th order',end
        switch(m)
            case 0
                val = z.*(z.^6 - 21/2*z.^4.*rho2 + 105/8*z.^2.*rho4 - 35/16*rho6)./r.^7;
            case 1
                val = x.*(z.^6 - 15/4*z.^4.*rho2 + 15/8*z.^2.*rho4 - 5/64*rho6)./r.^7;
            case -1
                val = y.*(z.^6 - 15/4*z.^4.*rho2 + 15/8*z.^2.*rho4 - 5/64*rho6)./r.^7;
            case 2
                val = z.*(x.^2 - y.^2).*(z.^4 - 5/3*z.^2.*rho2 + 5/16*rho4)./r.^7;
            case -2
                val = z.*x.*y.*(z.^4 - 5/3*z.^2.*rho2 + 5/16*rho4)./r.^7;
            case 3
                val = x.*(x.^2 - 3*y.^2).*(z.^4 - 3/4*z.^2.*rho2 + 3/80*rho4)./r.^7;
            case -3                
                val = y.*(3*x.^2 - y.^2).*(z.^4 - 3/4*z.^2.*rho2 + 3/80*rho4)./r.^7;
            case 4
                val = z.*(x.^4 - 6*x.^2.*y.^2 + y.^4).*(z.^2 - 3/10*rho2)./r.^7;
            case -4                
                val = z.*x.*y.*(x.^2 - y.^2).*(z.^2 - 3/10*rho2)./r.^7;
            case 5
                val = x.*(x.^4 - 10*x.^2.*y.^2 + 5*y.^4).*(z.^2 - 1/12*rho2)./r.^7;
            case -5
                val = y.*(y.^4 - 10*x.^2.*y.^2 + 5*x.^4).*(z.^2 - 1/12*rho2)./r.^7;
            case 6
                val = z.*(x.^2 - y.^2).*(x.^4 - 14*x.^2.*y.^2 + y.^4)./r.^7;
            case -6
                val = z.*x.*y.*(x.^2 - 3*y.^2).*(3*x.^2 - y.^2)./r.^7;
            case 7
                val = x.*(x.^6 - 21*x.^4.*y.^2 + 35*x.^2.*y.^4 - 7*y.^6)./r.^7;
            case -7
                val = y.*(y.^6 - 21*y.^4.*x.^2 + 35*y.^2.*x.^4 - 7*x.^6)./r.^7;
            otherwise
                error('order or degree of spherical harmonic does not exist');
        end
    case 8
        if normalization, error 'normalization not implemented for 8th order',end
        switch(m)
            case  0, val = (z.^8 - 14*z.^6.*rho2 + 105/4*z.^4.*rho4 - 35/4*z.^2.*rho6 + 35/128.*rho8)./r.^8;
            case  1, val = x.*z.*(z.^6 - 21/4*z.^4.*rho2 + 35/8*z.^2.*rho4 - 35/64*rho6)./r.^8;
            case -1, val = y.*z.*(z.^6 - 21/4*z.^4.*rho2 + 35/8*z.^2.*rho4 - 35/64*rho6)./r.^8;
            case  2, val = (x.^2 - y.^2).*(z.^6 - 5/2*z.^4.*rho2 + 15/16*z.^2.*rho4 - 1/32*rho6)./r.^8;
            case -2, val = x.*y.*(z.^6 - 5/2*z.^4.*rho2 + 15/16*z.^2.*rho4 - 1/32*rho6)./r.^8;
            case  3, val = z.*x.*(x.^2 - 3*y.^2).*(z.^4 - 5/4*z.^2.*rho2 + 3/16*rho4)./r.^8;
            case -3, val = z.*y.*(3*x.^2 - y.^2).*(z.^4 - 5/4*z.^2.*rho2 + 3/16*rho4)./r.^8;
            case  4, val = (x.^4 - 6*x.^2.*y.^2 + y.^4).*(z.^4 - 3/5*z.^2.*rho2 + 1/40.*rho4)./r.^8;
            case -4, val = x.*y.*(x.^2 - y.^2).*(z.^4 - 3/5*z.^2.*rho2 + 1/40.*rho4)./r.^8;
            case  5, val = z.*x.*(x.^4 - 10*x.^2.*y.^2 + 5*y.^4).*(z.^2 - 1/4*rho2)./r.^8;
            case -5, val = z.*y.*(y.^4 - 10*x.^2.*y.^2 + 5*x.^4).*(z.^2 - 1/4*rho2)./r.^8;
            case  6, val = (x.^2 - y.^2).*(x.^4 - 14*x.^2.*y.^2 + y.^4).*(z.^2 - 1/14*rho2)./r.^8;
            case -6, val = x.*y.*(x.^2 - 3*y.^2).*(3*x.^2 - y.^2).*(z.^2 - 1/14*rho2)./r.^8;
            case  7, val = z.*x.*(x.^6 - 21*x.^4.*y.^2 + 35*x.^2.*y.^4 - 7*y.^6)./r.^8;
            case -7, val = z.*y.*(y.^6 - 21*y.^4.*x.^2 + 35*y.^2.*x.^4 - 7*x.^6)./r.^8;
            case  8, val = (x.^8 - 28*x.^6.*y.^2 + 70*x.^4.*y.^4 - 28*x.^2.*y.^6 + y.^8)./r.^8;
            case -8, val = x.*y.*(x.^6 - 7*x.^4.*y.^2 + 7*x.^2.*y.^4 - y.^6)./r.^8;
            otherwise
                error('order or degree of spherical harmonic does not exist');
        end
    case 9
        if normalization, error 'normalization not implemented for 9th order',end
        switch(m)
            case  0, val = z.*(z.^8 - 18*z.^6.*rho2 + 189/4*z.^4.*rho4 - 105/4*z.^2.*rho6 + 315/128*rho8)./r.^9;
            case  1, val = x.*(z.^8 - 7*z.^6.*rho2 + 35/8*z.^4.*rho4 - 35/16*z.^2.*rho6 + 7/128*rho8)./r.^9;
            case -1, val = y.*(z.^8 - 7*z.^6.*rho2 + 35/8*z.^4.*rho4 - 35/16*z.^2.*rho6 + 7/128*rho8)./r.^9;
            case  2, val = z.*(x.^2 - y.^2).*(z.^6 - 7/2*z.^4.*rho2 + 35/16*z.^2.*rho4 + 7/32*rho6)./r.^9;
            case -2, val = z.*x.*y.*         (z.^6 - 7/2*z.^4.*rho2 + 35/16*z.^2.*rho4 + 7/32*rho6)./r.^9;
            case  3, val = x.*(x.^2 - 3*y.^2).*(z.^6 - 15/8*z.^4.*rho2 + 9/16*z.^2.*rho4 + 1/64*rho6)./r.^9;
            case -3, val = y.*(3*x.^2 - y.^2).*(z.^6 - 15/8*z.^4.*rho2 + 9/16*z.^2.*rho4 + 1/64*rho6)./r.^9;
            case  4, val = z.*(x.^4 - 6*x.^2.*y.^2 + y.^4).*(z.^4 - z.^2.*rho2 + 1/8.*rho4)./r.^9;
            case -4, val = z.*x.*y.*(x.^2 - y.^2).*         (z.^4 - z.^2.*rho2 + 1/8.*rho4)./r.^9;
            case  5, val = x.*(x.^4 - 10*x.^2.*y.^2 + 5*y.^4).*(z.^2 - 1/2*z.^2.*rho2 + 1/56*rho4)./r.^9;
            case -5, val = y.*(y.^4 - 10*x.^2.*y.^2 + 5*x.^4).*(z.^2 - 1/2*z.^2.*rho2 + 1/56*rho4)./r.^9;
            case  6, val = z.*(x.^2 - y.^2).*(x.^4 - 14*x.^2.*y.^2 + y.^4).*(z.^2 - 3/14*rho2)./r.^9;
            case -6, val = z.*x.*y.*(x.^2 - 3*y.^2).*(3*x.^2 - y.^2).*(z.^2 - 3/14*rho2)./r.^9;
            case  7, val = x.*(x.^6 - 21*x.^4.*y.^2 + 35*x.^2.*y.^4 - 7*y.^6).*(z.^2 - 1/16*rho2)./r.^9;
            case -7, val = y.*(y.^6 - 21*y.^4.*x.^2 + 35*y.^2.*x.^4 - 7*x.^6).*(z.^2 - 1/16*rho2)./r.^9;
            case  8, val = z.*(x.^8 - 28*x.^6.*y.^2 + 70*x.^4.*y.^4 - 28*x.^2.*y.^6 + y.^8)./r.^9;
            case -8, val = z.*x.*y.*(x.^6 - 7*x.^4.*y.^2 + 7*x.^2.*y.^4 - y.^6)./r.^9;
            case  9, val = x.*(x.^8 - 36*x.^6.*y.^2 + 126*x.^4.*y.^4 - 84*x.^2.*y.^6 + 9*y.^8)./r.^9;
            case -9, val = y.*(y.^8 - 36*y.^6.*x.^2 + 126*y.^4.*x.^4 - 84*y.^2.*x.^6 + 9*x.^8)./r.^9;
            otherwise
                error('order or degree of spherical harmonic does not exist');
        end
    otherwise
    error('order or degree of spherical harmonic does not exist');
end
