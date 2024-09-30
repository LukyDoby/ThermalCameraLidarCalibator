function [all_coeffs] = getTheEquationOfPlane(points)
    
    P = points(1,:);
    Q = points(2,:);
    R = points(3,:);

    a = Q-P;
    b = R-P;
    n = cross(a,b);  % normal vector of the plane


    syms x y z d 
    eq = n(1)*(x-P(1)) + n(2)*(y-P(2)) + n(3)*(z-P(3)) == 0;
    eqn_standard = lhs(eq) - rhs(eq);
    all_coeffs = coeffs(eqn_standard, [x,y,z]);
    all_coeffs = double(all_coeffs);
    all_coeffs = fliplr(all_coeffs); % flip to start with x- coeff
    
end