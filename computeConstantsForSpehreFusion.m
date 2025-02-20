function [a_0, a_1, A_0, A_1, a_x, a_y] = computeConstantsForSpehreFusion(ptImCentersCell)

%% prolozeni MNČ primkou

ptCenters = cell2mat(ptImCentersCell(:,1));
imCenters = cell2mat(ptImCentersCell(:,3));

x_im = imCenters(:,1);
sum_x_i = sum(x_im);
sum_x_i_square = sum(x_im.^2);

y_im = imCenters(:,2); 
sum_y_i = sum(y_im);
sum_y_i_square = sum(y_im.^2);

%% Convert ptCloud to azimuth and elevation
az_elev = [];
for k = 1:length(ptCenters)
    [azim, elev] = cartesianToSpherical(ptCenters(k,1),ptCenters(k,2),ptCenters(k,3));
    az_elev(end+1,:) = [azim, elev];
end

sum_az = sum(az_elev(:,1));
sum_elev = sum(az_elev(:,2));

sum_xi_az = [];
sum_yi_elev = [];
for k = 1:length(az_elev)

    sum_xi_az(end+1) = x_im(k) * az_elev(k,1);
    sum_yi_elev(end+1) = y_im(k) * az_elev(k,2);
    

end
sum_xi_az = sum(sum_xi_az);
sum_yi_elev = sum(sum_yi_elev);

%% ziskani a_0, a_1, imgX - azimut 

A = [1 sum_x_i; sum_x_i sum_x_i_square];
b = [sum_az; sum_xi_az];
x = inv(A)*b;

a_0 = x(1);
a_1 = x(2);

%% ziskani A_0 a A_1, img_Y - elevace

A = [1 sum_y_i; sum_y_i sum_y_i_square];
b = [sum_elev; sum_yi_elev];
x = inv(A)*b;

A_0 = x(1);
A_1 = x(2);

%% Nova data

x_bar = a_0*imCenters(:,1) + a_1;
y_bar = A_0*imCenters(:,2) + A_1;

%% Solve polynomial equation

% solving for x

A = [];
b = [];
x = az_elev(:,1);       % azimuth
y = az_elev(:,2);       % elevation

for k = 1:length(az_elev)
   A(end+1,:) = [1  x(k)  y(k)  x(k)^2  x(k)*y(k)  y(k)^2  x(k)^3  x(k)^2*y(k)  x(k)*y(k)^2  y(k)^3  x(k)^4  x(k)^3*y(k)  x(k)^2*y(k)^2  x(k)*y(k)^3  y(k)^4];
    
  %A(end+1,:) = [1  x(i)  y(i)  x(i)^2  x(i)*y(i)  y(i)^2  x(i)^3  x(i)^2*y(i)  x(i)*y(i)^2  y(i)^3  x(i)^4  x(i)^3*y(i)  x(i)^2*y(i)^2  x(i)*y(i)^3  y(i)^4  x(i)^5  x(i)^4*y(i) x(i)^3*y(i)^2  x(i)^2*y(i)^3  x(i)*y(i)^4  y(i)^5];   % polynom 5. stupne
   
 % A(end+1,:) = [1  x(i)  y(i)  x(i)^2  x(i)*y(i)  y(i)^2  x(i)^3  x(i)^2*y(i)  x(i)*y(i)^2  y(i)^3];
  b(end+1,:) = x_bar(k);

end

a_x = inv(A'*A)*A'*b;

% Solving for y


A = [];
b = [];
x = az_elev(:,1);       % azimuth
y = az_elev(:,2);       % elevation

for k = 1:length(az_elev)
    A(end+1,:) = [1  x(k)  y(k)  x(k)^2  x(k)*y(k)  y(k)^2  x(k)^3  x(k)^2*y(k)  x(k)*y(k)^2  y(k)^3  x(k)^4  x(k)^3*y(k)  x(k)^2*y(k)^2  x(k)*y(k)^3  y(k)^4];
    
   % A(end+1,:) = [1  x(i)  y(i)  x(i)^2  x(i)*y(i)  y(i)^2  x(i)^3  x(i)^2*y(i)  x(i)*y(i)^2  y(i)^3  x(i)^4  x(i)^3*y(i)  x(i)^2*y(i)^2  x(i)*y(i)^3  y(i)^4  x(i)^5  x(i)^4*y(i) x(i)^3*y(i)^2  x(i)^2*y(i)^3  x(i)*y(i)^4  y(i)^5];   % polynom 5. stupne
   
  %A(end+1,:) = [1  x(i)  y(i)  x(i)^2  x(i)*y(i)  y(i)^2  x(i)^3  x(i)^2*y(i)  x(i)*y(i)^2  y(i)^3];
  b(end+1,:) = y_bar(k);

end

a_y = inv(A'*A)*A'*b;

end