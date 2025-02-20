function [z_x, z_y] = getPixelPosition(x,y,a_x,a_y)

z_x = a_x(1) + a_x(2)*x + a_x(3)*y + a_x(4)*x^2 + a_x(5)*x*y + a_x(6)*y^2 + a_x(7)*x^3 + a_x(8)*x^2*y + a_x(9)*x*y^2  + a_x(10)*y^3 + a_x(11)*x^4 + a_x(12)*x^3*y + a_x(13)*x^2*y^2 + a_x(14)*x*y^3 + a_x(15)*y^4;

z_y = a_y(1) + a_y(2)*x + a_y(3)*y + a_y(4)*x^2 + a_y(5)*x*y + a_y(6)*y^2 + a_y(7)*x^3 + a_y(8)*x^2*y + a_y(9)*x*y^2  + a_y(10)*y^3 + a_y(11)*x^4 + a_y(12)*x^3*y + a_y(13)*x^2*y^2 + a_y(14)*x*y^3 + a_y(15)*y^4;


% z_x = a_x(1) + a_x(2)*x + a_x(3)*y + a_x(4)*x^2 + a_x(5)*x*y + a_x(6)*y^2 + a_x(7)*x^3 + a_x(8)*x^2*y + a_x(9)*x*y^2  + a_x(10)*y^3 + a_x(11)*x^4 + a_x(12)*x^3*y + a_x(13)*x^2*y^2 + a_x(14)*x*y^3 + a_x(15)*y^4 + a_x(16)*x^5 + a_x(17)*x^4*y + a_x(18)*x^3*y^2 + a_x(19)*x^2*y^3 + a_x(20)*x*y^4+ a_x(21)*y^5;
% 
% z_y = a_y(1) + a_y(2)*x + a_y(3)*y + a_y(4)*x^2 + a_y(5)*x*y + a_y(6)*y^2 + a_y(7)*x^3 + a_y(8)*x^2*y + a_y(9)*x*y^2  + a_y(10)*y^3 + a_y(11)*x^4 + a_y(12)*x^3*y + a_y(13)*x^2*y^2 + a_y(14)*x*y^3 + a_y(15)*y^4 +a_y(16)*x^5 + a_y(17)*x^4*y + a_y(18)*x^3*y^2 + a_y(19)*x^2*y^3 + a_y(20)*x*y^4+ a_y(21)*y^5;
 
% z_x = a_x(1) + a_x(2)*x + a_x(3)*y + a_x(4)*x^2 + a_x(5)*x*y + a_x(6)*y^2 + a_x(7)*x^3 + a_x(8)*x^2*y + a_x(9)*x*y^2  + a_x(10)*y^3;
% z_y = a_y(1) + a_y(2)*x + a_y(3)*y + a_y(4)*x^2 + a_y(5)*x*y + a_y(6)*y^2 + a_y(7)*x^3 + a_y(8)*x^2*y + a_y(9)*x*y^2  + a_y(10)*y^3;

end