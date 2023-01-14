function err = optimfunc1(dh_params)
%% Loss function to minimized
% The dh parameters to be passed in order as [d1, a1, alpha1, d2, a2, alpha2, theta3, a3, alpha3, offset1, offset2]
% Can be called with fminsearch as fminsearch(@optimfunc, init_params)
% where init_params is the initial guess of the dh parameters.
%% Get parameters and create robot model
    
    
    %set initial theta values to zero
    theta1 = 0;
    theta2 = 0;
    
    %Extract dh parameters from the array
    d1 = dh_params(1);
    d2 = dh_params(4);
    theta3 = dh_params(7);
    a1 = dh_params(2);
    a2 = dh_params(5);
    a3 = dh_params(8);
    alpha1 = dh_params(3); 
    alpha2 = dh_params(6);
    alpha3 = dh_params(9);
    off1 = dh_params(10);
    off2 = dh_params(11);
    
    %Create robot
    L(1) = Link([theta1, d1, a1, alpha1, 0]);
    L(1).offset = off1;
    L(2) = Link([theta2, d2, a2, alpha2, 0]);
    L(2).offset = off2;
    L(3) = Link('prismatic', 'theta', theta3, 'a', a3, 'alpha', alpha3);
    L(3).qlim = [0 8];

    robot = SerialLink(L, "name", "robot");

    %Base offset transformation
    t = eul2tr([pi/2, 0, 0]);
    t(1:3, 4) = [7.9, 0, 7.6]';

    robot.base = t;


    
    %% Read ground truth values and calculate error


    values = load("data.mat");

    theta = values.data(:,1:2);
    theta(:,3) = zeros(size(values.data,1), 1);
    
    x_y_gt = values.data(:,3:4);
    calc_vals = double(robot.fkine(theta)); %calculated value from robot model
    x_y_calc = squeeze(calc_vals(1:2, 4, :));
    x_y_calc = x_y_calc';
    err = sqrt(sum(((x_y_gt - x_y_calc).^2), 2));
    err = mean(err);
%     robot.plot(theta); % Plot robot to see changes
end    
