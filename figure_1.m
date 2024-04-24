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
surf(X, Y, Z, 'FaceAlpha', 0.5) % Create surface plot with 50% transparency
hold on; % Hold the current plot to add lines

% Add a line down the middle of the cone
line([0 0], [0 0], [0 -1], 'Color', 'red', 'LineWidth', 2) % Vertical line down the Z axis

% Add a line starting at the origin and pointing left
line([0 -1], [0 0], [0 0], 'Color', 'blue', 'LineWidth', 2) % Horizontal line along the negative X axis

% Set axis properties
axis equal % Ensure all axes have the same scale
xlim(x_limits);
ylim(y_limits);
zlim(z_limits);
xlabel('X-axis')
ylabel('Y-axis')
zlabel('Z-axis')
title('Translucent Cone')
view(3); % Set 3D view for the cone plot
grid on; % Turn on grid for the cone plot
hold off; % Release the hold to finish plotting

% Define vertices for a pyramid pointing downward
V = [1 1 -1; -1 1 -1; -1 -1 -1; 1 -1 -1; 0 0 0]; % Base and apex
F = [1 2 5; 2 3 5; 3 4 5; 4 1 5; 1 2 3; 3 4 1]; % Faces connecting vertices

% Subplot for the pyramid
subplot(1, 2, 2); % Second subplot in a 1x2 grid
patch('Vertices', V, 'Faces', F, 'FaceColor', 'blue', 'FaceAlpha', 0.5)
hold on; % Hold the current plot to add lines

% Add a line from the apex to the base center
line([0 0], [0 0], [0 -1], 'Color', 'red', 'LineWidth', 2) % Vertical line down the Z axis from apex to base center
% Add a line starting at the origin and pointing left
line([0 -1], [0 0], [0 0], 'Color', 'blue', 'LineWidth', 2) % Horizontal line along the negative X axis

% Set the same axis properties
axis equal % Ensure all axes have the same scale
xlim(x_limits);
ylim(y_limits);
zlim(z_limits);
xlabel('X-axis')
ylabel('Y-axis')
zlabel('Z-axis')
title('Translucent Pyramid')
view(3); % Set 3D view for the pyramid plot
grid on; % Turn on grid for the pyramid plot
hold off; % Release the hold to finish plotting
