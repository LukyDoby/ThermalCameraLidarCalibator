function [azim, elev] = cartesianToSpherical(X,Y,Z)

    azim = atan2(Y,X);
   elev = atan2(Z, sqrt(X^2 + Y^2));
    
end