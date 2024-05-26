% Define the range for the variables for the cone
theta = linspace(0, 2*pi, 30); % Angle around the cone
h = linspace(0, 1, 20); % Height from 0 to 1 (height of the cone)
[Theta, H] = meshgrid(theta, h);

% Radius of the cone at each height (linearly proportional to the height)
R = H; % Radius increases with height

% Convert polar coordinates to Cartesian coordinates for plotting the cone
X = R .* cos(Theta);
Y = R .* sin(Theta);
Z = -H; % Make Z negative to point the cone downward

% Define axis limits
x_limits = [-1.5, 1.5];
y_limits = [-1.5, 1.5];
z_limits = [-1.5, 0.5];

% Create the figure and subplot for the cone
figure;
subplot(1, 2, 1); % First subplot in a 1x2 grid
hCone = surf(X, Y, Z, 'FaceAlpha', 0.5); % Create surface plot with 50% transparency
hold on; % Hold the current plot

% Initialize the red line on the cone
hLineCone = line([0 0], [0 0], [0 -1], 'Color', 'red', 'LineWidth', 2);

% Add a line starting at the origin and pointing left
line([0 -1], [0 0], [0 0], 'Color', 'blue', 'LineWidth', 2) % Horizontal line along the negative X axis

axis equal % Ensure all axes have the same scale
xlim(x_limits);
ylim(y_limits);
zlim(z_limits);
xlabel('X-axis')
ylabel('Y-axis')
zlabel('Z-axis')
title('Dependent Components')
view(3); % Set 3D view for the cone plot
grid on; % Turn on grid for the cone plot

% Define vertices for a pyramid pointing downward
V = [1 1 -1; -1 1 -1; -1 -1 -1; 1 -1 -1; 0 0 0]; % Base and apex
F = [1 2 5; 2 3 5; 3 4 5; 4 1 5; 1 2 3; 3 4 1]; % Faces connecting vertices

% Subplot for the pyramid
subplot(1, 2, 2); % Second subplot in a 1x2 grid
hPyramid = patch('Vertices', V, 'Faces', F, 'FaceColor', 'blue', 'FaceAlpha', 0.5);
hold on; % Hold the current plot

% Initialize the red line on the pyramid
hLinePyramid = line([0 0], [0 0], [0 -1], 'Color', 'red', 'LineWidth', 2);

% Add a line starting at the origin and pointing left
line([0 -1], [0 0], [0 0], 'Color', 'blue', 'LineWidth', 2) % Horizontal line along the negative X axis

axis equal % Ensure all axes have the same scale
xlim(x_limits);
ylim(y_limits);
zlim(z_limits);
xlabel('X-axis')
ylabel('Y-axis')
zlabel('Z-axis')
title('Independent Components')
view(3); % Set 3D view for the pyramid plot
grid on; % Turn on grid for the pyramid plot

% Endless animation loop for the rotating line
while ishandle(hCone) % Continue as long as the figure exists
    for t = linspace(0, 2*pi, 360)
        % Update line position in the cone plot
        set(hLineCone, 'XData', [0 cos(t)], 'YData', [0 sin(t)], 'ZData', [0 -1]);

        % Update line position in the pyramid plot
        set(hLinePyramid, 'XData', [0 cos(t)], 'YData', [0 sin(t)], 'ZData', [0 -1]);

        drawnow % Update the plots
    end
end

hold off; % Release the hold to finish plotting
