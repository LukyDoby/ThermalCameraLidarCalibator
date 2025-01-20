function desk_corners = detectDeskCorners(im, line_coords, image_pts_checker,boardSize)
    
    %% Prvne spocitame smernice naklonu sachovnicove desky - vemzmeme LH, LD a LH, PH

    LH = image_pts_checker(1,:);
    LD = image_pts_checker(boardSize(1) - 1, :);
    PH = image_pts_checker((boardSize(1) -1)*(boardSize(2) -1) - boardSize(1) + 2, :);
    PD = image_pts_checker((boardSize(1)-1) * (boardSize(2)-1),:);

    smer_left = (LD(2) - LH(2))/(LD(1) - LH(1));
    smer_up = (PH(2) - LH(2))/(PH(1) - LH(1));
    smer_right = (PH(2) - PD(2))/(PH(1) - PD(1));
    smer_down = (PD(2) - LD(2))/(PD(1) - LD(1));

    %% vypocet smernic vsech primek pomoci LSD

    x1 = line_coords(:,:,1);
    y1 = line_coords(:,:,2);
    x2 = line_coords(:,:,3);
    y2 = line_coords(:,:,4);

    tan_of_all_lines = (y2 - y1)./(x2 - x1);

    %% Plotting result

   figure(1); imshow(im); hold on;
    for k = 1:length(line_coords)
        plot([x1(k), x2(k)], [y1(k), y2(k)], 'LineWidth', 2); % Plot the line
    end

    % close all;


    %% selekce primek, ktere maji tangentu blizkou smernici natoceni sachovnice

    thresh = 0.11;
    x1_fin = [];
    x2_fin = [];
    y1_fin = [];
    y2_fin = [];
    for i = 1:length(line_coords)
        if(abs(abs(smer_left) - abs(tan_of_all_lines(i))) <= thresh || abs(abs(smer_up) - abs(tan_of_all_lines(i))) <= thresh)
            x1_fin(end+1,:) = x1(i);
            x2_fin(end+1,:) = x2(i);
            y1_fin(end+1,:) = y1(i);
            y2_fin(end+1,:) = y2(i);
           
        end
    end

    % Plotting result

    figure(2);imshow(im); hold on;
    for k = 1:length(x1_fin)
        plot([x1_fin(k), x2_fin(k)], [y1_fin(k), y2_fin(k)], 'LineWidth', 2); % Plot the line
    end

    close all;

    %% Selekce primek na zaklade vzdalenosti od sachovnice

  %   thrs_low = 20;
  %   thrs_high = 100;
  % 
  %   idx_to_remove = [];
  %   for i = 1:length(x1_fin)
  % 
  %      d_LH = point_to_line_distance(LH(1), LH(2), x1_fin(i), y1_fin(i), x2_fin(i), y2_fin(i));
  %      d_LD = point_to_line_distance(LD(1), LH(2), x1_fin(i), y1_fin(i), x2_fin(i), y2_fin(i));
  %      d_PH = point_to_line_distance(PH(1), PH(2), x1_fin(i), y1_fin(i), x2_fin(i), y2_fin(i));
  % 
  %      if~(d_LH > thrs_low && d_LH > thrs_high || d_LD > thrs_low && d_LD > thrs_high || d_PH > thrs_low && d_PH > thrs_high)
  % 
  %          idx_to_remove(end+1,:) = i;
  %      end
  % 
  %   end
  % 
  %   x1_fin(idx_to_remove) = [];
  %   x2_fin(idx_to_remove) = [];
  %   y1_fin(idx_to_remove) = [];
  %   y2_fin(idx_to_remove) = [];
  % 
  %     % Plotting result
  % 
  % figure(1); imshow(im); hold on;
  %   for k = 1:length(x1_fin)
  %       plot([x1_fin(k), x2_fin(k)], [y1_fin(k), y2_fin(k)], 'LineWidth', 2); % Plot the line
  %   end
  % 
  % 
  %  % Kontrola jestli hranice lezi ve spravne polorovine danou hranicni primkou
  % 
  %  Check if the point is in the positive half-plane
  %  figure(2); imshow(im); hold on;
  %  points_up = [];
  %  go_out = 0;
  %  dist_thresh_low = 3;
  %  dist_thresh_high = 100;
  %  smer_down = abs(smer_down);
  %  smer_up = abs(smer_up);
  %  smer_left = abs(smer_left);
  %  smer_right =abs(smer_right);
  % 
  %  for i = 1:length(x1_fin)
  %        Specify 'positive' or 'negative'
  %       isInHalfPlane_up_1 = point_in_half_plane(x1_fin(i), y1_fin(i), LH(1), LH(2), PH(1), PH(2), 'positive');
  %       isInHalfPlane_up_2 = point_in_half_plane(x2_fin(i), y2_fin(i), LH(1), LH(2), PH(1), PH(2), 'positive');
  % 
  %       isInHalfPlane_left_1 = point_in_half_plane(x1_fin(i), y1_fin(i), LH(1), LH(2), LD(1), LD(2), 'negative');
  %       isInHalfPlane_left_2 = point_in_half_plane(x2_fin(i), y2_fin(i), LH(1), LH(2), LD(1), LD(2), 'negative');
  % 
  %       isInHalfPlane_right_1 = point_in_half_plane(x1_fin(i), y1_fin(i), PH(1), PH(2), PD(1), PD(2), 'positive');
  %       isInHalfPlane_right_2 = point_in_half_plane(x2_fin(i), y2_fin(i), PH(1), PH(2), PD(1), PD(2), 'positive');
  % 
  %       isInHalfPlane_down_1 = point_in_half_plane(x1_fin(i), y1_fin(i), LD(1), LD(2), PD(1), PD(2), 'negative');
  %       isInHalfPlane_down_2 = point_in_half_plane(x2_fin(i), y2_fin(i), LD(1), LD(2), PD(1), PD(2), 'negative');
  % 
  %       if isInHalfPlane_up_1 && isInHalfPlane_up_2 && go_out == 0 
  %           smer_act = abs((y2_fin(i) - y1_fin(i))/(x1_fin(i) - x2_fin(i)));
  %           d = point_to_line_distance(x1_fin(i), y1_fin(i), LH(1), LH(2), PH(1), PH(2));
  %           if(abs(smer_act - smer_up) <= thresh && d > dist_thresh_low && d < dist_thresh_high)
  %               plot([x1_fin(i), x2_fin(i)], [y1_fin(i), y2_fin(i)], 'LineWidth', 2); % Plot the line
  %               hold on;
  %               points_up(end+1,:) = [x1_fin(i), y1_fin(i), x2_fin(i), y2_fin(i)];
  %           end
  % 
  %           go_out = 1;
  % 
  %       end
  %       if isInHalfPlane_left_1 && isInHalfPlane_left_2 && go_out == 0
  %           smer_act = abs((y2_fin(i) - y1_fin(i))/(x1_fin(i) - x2_fin(i)));
  %           d = point_to_line_distance(x1_fin(i), y1_fin(i),LH(1), LH(2), LD(1), LD(2));
  %           if( abs(smer_act - smer_left) <= thresh && d > dist_thresh_low && d < dist_thresh_high)
  %               plot([x1_fin(i), x2_fin(i)], [y1_fin(i), y2_fin(i)], 'LineWidth', 2); % Plot the line
  %               hold on;
  %               points_up(end+1,:) = [x1_fin(i), y1_fin(i), x2_fin(i), y2_fin(i)];
  %           end
  %           go_out = 1;
  % 
  %       end
  %       if isInHalfPlane_right_1 && isInHalfPlane_right_2 && go_out == 0
  %           smer_act = abs((y2_fin(i) - y1_fin(i))/(x1_fin(i) - x2_fin(i)));
  %           d = point_to_line_distance(x1_fin(i), y1_fin(i),PH(1), PH(2), PD(1), PD(2));
  %           if(abs(smer_act - smer_right) <= thresh && d > dist_thresh_low && d < dist_thresh_high)
  %               plot([x1_fin(i), x2_fin(i)], [y1_fin(i), y2_fin(i)], 'LineWidth', 2); % Plot the line
  %               hold on;
  %               points_up(end+1,:) = [x1_fin(i), y1_fin(i), x2_fin(i), y2_fin(i)];
  %           end
  %           go_out = 1;
  % 
  %       end
  %       if isInHalfPlane_down_1 && isInHalfPlane_down_2 && go_out == 0
  %           smer_act = abs((y2_fin(i) - y1_fin(i))/(x1_fin(i) - x2_fin(i)));
  %           d = point_to_line_distance(x1_fin(i), y1_fin(i),LD(1), LD(2),PD(1), PD(2));
  %           if( abs(smer_act - smer_down) <= thresh && d > dist_thresh_low && d < dist_thresh_high)
  %               plot([x1_fin(i), x2_fin(i)], [y1_fin(i), y2_fin(i)], 'LineWidth', 2); % Plot the line
  %               hold on;
  %               points_up(end+1,:) = [x1_fin(i), y1_fin(i), x2_fin(i), y2_fin(i)];
  %           end
  %           go_out = 1;
  % 
  %       end
  %       go_out = 0;
  %  end

end