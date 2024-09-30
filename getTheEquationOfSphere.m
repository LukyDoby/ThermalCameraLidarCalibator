function [center,radius] = getTheEquationOfSphere(points)
    
    syms x y z u v w d 
    eq = x^2 + y^2 + z^2 + 2*u*x + 2*v*y + 2*w*z + d == 0;
    
    eq_1 = subs(eq, [x, y, z], points(1,:));
    eq_2 = subs(eq, [x, y, z], points(2,:));
    eq_3 = subs(eq, [x, y, z], points(3,:));
    eq_4 = subs(eq, [x, y, z], points(4,:));
    
    [A,B] = equationsToMatrix([eq_1, eq_2, eq_3, eq_4], [u, v, w, d]);
    x = double(inv(A)*B);
    center = [-x(1) -x(2) -x(3)];
    radius = double(sqrt(x(1)^2 + x(2)^2 + x(3)^2 - x(4)));
end