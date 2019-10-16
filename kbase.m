% basis
% basis_nr is order of basis starting with 0 to ...
% coord is a column vector of coordinates (x,y,z)
function val = kbase(basis_nr,coord,normalisation)
if nargin < 3
    normalisation = false;
end
switch basis_nr
    case 1
        val=spha(0,0,coord,normalisation);
    case 2
        val=spha(1,0,coord,normalisation);
    case 3
        val=spha(1,1,coord,normalisation);
    case 4
        val=spha(1,-1,coord,normalisation);
    case 5
        val=spha(2,0,coord,normalisation);
    case 6
        val=spha(2,1,coord,normalisation);
    case 7
        val=spha(2,-1,coord,normalisation);
    case 8
        val=spha(2,2,coord,normalisation);
    case 9
        val=spha(2,-2,coord,normalisation);
    case 10
        val=spha(3,0,coord,normalisation);
    case 11
        val=spha(3,1,coord,normalisation);
    case 12
        val=spha(3,-1,coord,normalisation);
    case 13
        val=spha(3,2,coord,normalisation);
    case 14
        val=spha(3,-2,coord,normalisation);
    case 15
        val=spha(3,3,coord,normalisation);    
    case 16
        val=spha(3,-3,coord,normalisation);
    case 17
        val=spha(4,0,coord,normalisation);
    case 18
        val=spha(4,1,coord,normalisation);
    case 19
        val=spha(4,-1,coord,normalisation);
    case 20
        val=spha(4,2,coord,normalisation);
    case 21
        val=spha(4,-2,coord,normalisation);
    case 22
        val=spha(4,3,coord,normalisation);
    case 23
        val=spha(4,-3,coord,normalisation);
    case 24
        val=spha(4,4,coord,normalisation);
    case 25
        val=spha(4,-4,coord,normalisation);
    case 26
        val=spha(5,0,coord,normalisation);
    case 27
        val=spha(5,1,coord,normalisation);
    case 28
        val=spha(5,-1,coord,normalisation);
    case 29
        val=spha(5,2,coord,normalisation);
    case 30
        val=spha(5,-2,coord,normalisation);
    case 31
        val=spha(5,3,coord,normalisation);
    case 32
        val=spha(5,-3,coord,normalisation);
    case 33
        val=spha(5,4,coord,normalisation);
    case 34
        val=spha(5,-4,coord,normalisation);
    case 35
        val=spha(5,5,coord,normalisation);
    case 36
        val=spha(5,-5,coord,normalisation);
    case 37
        val=spha(6,0,coord,normalisation);
    case 38
        val=spha(6,1,coord,normalisation);
    case 39
        val=spha(6,-1,coord,normalisation);
    case 40
        val=spha(6,2,coord,normalisation);
    case 41
        val=spha(6,-2,coord,normalisation);
    case 42
        val=spha(6,3,coord,normalisation);
    case 43
        val=spha(6,-3,coord,normalisation);
    case 44
        val=spha(6,4,coord,normalisation);
    case 45
        val=spha(6,-4,coord,normalisation);
    case 46
        val=spha(6,5,coord,normalisation);
    case 47
        val=spha(6,-5,coord,normalisation);
    case 48
        val=spha(6,6,coord,normalisation);
    case 49
        val=spha(6,-6,coord,normalisation);
    case 50, val=spha(7, 0,coord,normalisation);
    case 51, val=spha(7, 1,coord,normalisation);
    case 52, val=spha(7,-1,coord,normalisation);
    case 53, val=spha(7, 2,coord,normalisation);
    case 54, val=spha(7,-2,coord,normalisation);
    case 55, val=spha(7, 3,coord,normalisation);
    case 56, val=spha(7,-3,coord,normalisation);
    case 57, val=spha(7, 4,coord,normalisation);
    case 58, val=spha(7,-4,coord,normalisation);
    case 59, val=spha(7, 5,coord,normalisation);
    case 60, val=spha(7,-5,coord,normalisation);
    case 61, val=spha(7, 6,coord,normalisation);
    case 62, val=spha(7,-6,coord,normalisation);
    case 63, val=spha(7, 7,coord,normalisation);
    case 64, val=spha(7,-7,coord,normalisation);
    case 65, val=spha(8, 0,coord,normalisation);
    case 66, val=spha(8, 1,coord,normalisation);
    case 67, val=spha(8,-1,coord,normalisation);
    case 68, val=spha(8, 2,coord,normalisation);
    case 69, val=spha(8,-2,coord,normalisation);
    case 70, val=spha(8, 3,coord,normalisation);
    case 71, val=spha(8,-3,coord,normalisation);
    case 72, val=spha(8, 4,coord,normalisation);
    case 73, val=spha(8,-4,coord,normalisation);
    case 74, val=spha(8, 5,coord,normalisation);
    case 75, val=spha(8,-5,coord,normalisation);
    case 76, val=spha(8, 6,coord,normalisation);
    case 77, val=spha(8,-6,coord,normalisation);
    case 78, val=spha(8, 7,coord,normalisation);
    case 79, val=spha(8,-7,coord,normalisation);
    case 80, val=spha(8, 8,coord,normalisation);
    case 81, val=spha(8,-8,coord,normalisation);
    case 82, val=spha(9, 0,coord,normalisation);
    case 83, val=spha(9, 1,coord,normalisation);
    case 84, val=spha(9,-1,coord,normalisation);
    case 85, val=spha(9, 2,coord,normalisation);
    case 86, val=spha(9,-2,coord,normalisation);
    case 87, val=spha(9, 3,coord,normalisation);
    case 88, val=spha(9,-3,coord,normalisation);
    case 89, val=spha(9, 4,coord,normalisation);
    case 90, val=spha(9,-4,coord,normalisation);
    case 91, val=spha(9, 5,coord,normalisation);
    case 92, val=spha(9,-5,coord,normalisation);
    case 93, val=spha(9, 6,coord,normalisation);
    case 94, val=spha(9,-6,coord,normalisation);
    case 95, val=spha(9, 7,coord,normalisation);
    case 96, val=spha(9,-7,coord,normalisation);
    case 97, val=spha(9, 8,coord,normalisation);
    case 98, val=spha(9,-8,coord,normalisation);
    case 99, val=spha(9, 9,coord,normalisation);
    case 100, val=spha(9,-9,coord,normalisation);
    otherwise
        error('order of basis not implemented/defined');
end
