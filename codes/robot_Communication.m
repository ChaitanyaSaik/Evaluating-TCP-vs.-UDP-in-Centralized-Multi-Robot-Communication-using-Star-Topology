clc; clear; close all;

%% Parameters
num_robots = 6; % Number of robots
hub_id = num_robots + 1; % Hub node is separate
packet_loss_probability = 0.1; % Probability of packet loss
latency = 0.2; % Simulated communication latency in seconds
dynamic_movement = true; % Enable/disable dynamic robot movement
enable_collision_detection = true; % Enable/disable collision detection
protocol_type = 'TCP'; % Choose 'TCP' or 'UDP' for communication protocol
timeout = 0.5; % Timeout for acknowledgment in seconds

%% Initialize Network
% Robot Positions (Circular Layout)
angles = linspace(0, 2*pi, num_robots+1);
radius = 3;
positions = [radius * cos(angles(1:end-1)) + 4, 4;
             radius * sin(angles(1:end-1)) + 4, 4]';
hub_position = [4, 4];

% Initialize Performance Metrics
throughput = zeros(1, num_robots); % Messages received per robot
latency_log = []; % Log of message latencies
packet_delivery_ratio = 0; % Ratio of delivered messages to sent messages
collision_count = 0; % Number of collisions detected
packets_lost = 0; % Number of packets lost during communication
retransmission_count = 0; % Number of retransmissions

%% GUI Initialization
fig = figure('Name', 'Robot Communication Research', 'NumberTitle', 'off', 'Position', [100, 100, 1000, 500]);
axis([0 8 0 8]); hold on; grid on;
title('Robot Communication with Star Topology - Research Simulation');

% Draw Robots and Hub
robot_handles = gobjects(1, num_robots);
for i = 1:num_robots
    robot_handles(i) = text(positions(i, 1), positions(i, 2), '🤖', 'FontSize', 20, 'HorizontalAlignment', 'center', 'Color', 'black');
    text(positions(i, 1), positions(i, 2) + 0.3, sprintf('Robot %d', i), 'FontSize', 12, 'HorizontalAlignment', 'center', 'Color', 'black');
end

% Draw Hub
hub_handle = text(hub_position(1), hub_position(2), '📡', 'FontSize', 20, 'HorizontalAlignment', 'center', 'Color', 'blue');
text(hub_position(1), hub_position(2) + 0.3, 'Hub', 'FontSize', 12, 'HorizontalAlignment', 'center', 'Color', 'blue');

% Draw Connections
for i = 1:num_robots
    line([positions(i, 1), hub_position(1)], [positions(i, 2), hub_position(2)], 'Color', 'blue', 'LineStyle', '--');
end

%% User Input and Simulation
fprintf('Choose a condition to simulate:\n');
fprintf('1. Robot 1 sends a message → Hub → All Robots 2-6 (Broadcast).\n');
fprintf('2. All Robots 1-5 send messages → Hub → Robot 6 (Collective).\n');
fprintf('3. Robots 1 & 2 send messages → Hub → Robot 6 (Sequential).\n');
fprintf('4. Robots 1, 2, 3 send messages → Hub → Robots 4 & 5 (Multi-Destination).\n');
choice = input('Enter your choice (1-4): ');

% Reset performance metrics
throughput = zeros(1, num_robots);
latency_log = [];
collision_count = 0;
packets_lost = 0;
retransmission_count = 0;

switch choice
    case 1
        % Condition 1: Robot 1 sends a message to all robots through the hub
        message_content = input('Enter message from Robot 1: ', 's');
        fprintf('Robot 1 sends a message to the hub...\n');
        for dest = 2:num_robots
            [throughput, latency_log, packets_lost, retransmission_count] = send_message(1, dest, message_content, positions, hub_position, packet_loss_probability, latency, throughput, latency_log, packets_lost, protocol_type, timeout, retransmission_count);
        end
        fprintf('All robots have received the message.\n');

    case 2
        % Condition 2: All robots send messages to Robot 6 through the hub
        messages = cell(1, num_robots-1);
        for i = 1:num_robots-1
            messages{i} = input(sprintf('Enter message from Robot %d: ', i), 's');
        end
        fprintf('All robots send messages to the hub...\n');
        for i = 1:num_robots-1
            [throughput, latency_log, packets_lost, retransmission_count] = send_message(i, num_robots, messages{i}, positions, hub_position, packet_loss_probability, latency, throughput, latency_log, packets_lost, protocol_type, timeout, retransmission_count);
        end
        fprintf('Robot 6 received all messages.\n');

    case 3
        % Condition 3: Robots 1 & 2 send messages to Robot 6 through the hub
        message1 = input('Enter message from Robot 1: ', 's');
        message2 = input('Enter message from Robot 2: ', 's');
        fprintf('Robots 1 and 2 send messages to the hub...\n');
        [throughput, latency_log, packets_lost, retransmission_count] = send_message(1, num_robots, message1, positions, hub_position, packet_loss_probability, latency, throughput, latency_log, packets_lost, protocol_type, timeout, retransmission_count);
        [throughput, latency_log, packets_lost, retransmission_count] = send_message(2, num_robots, message2, positions, hub_position, packet_loss_probability, latency, throughput, latency_log, packets_lost, protocol_type, timeout, retransmission_count);
        fprintf('Robot 6 received the messages.\n');

    case 4
        % Condition 4: Robots 1, 2, 3 send messages to Robots 4 & 5 through the hub
        messages = cell(1, 3);
        for i = 1:3
            messages{i} = input(sprintf('Enter message from Robot %d: ', i), 's');
        end
        fprintf('Robots 1, 2, and 3 send messages to the hub...\n');
        for i = 1:3
            for dest = 4:5
                [throughput, latency_log, packets_lost, retransmission_count] = send_message(i, dest, messages{i}, positions, hub_position, packet_loss_probability, latency, throughput, latency_log, packets_lost, protocol_type, timeout, retransmission_count);
            end
        end
        fprintf('Robots 4 and 5 received the messages.\n');

    otherwise
        error('Invalid choice. Please choose a number between 1 and 4.');
end

%% Display Performance Metrics
fprintf('\n=== Simulation Results ===\n');
fprintf('Packet Delivery Ratio: %.2f%%\n', (sum(throughput) / (num_robots * (num_robots - 1))) * 100);
fprintf('Average Latency: %.2f seconds\n', mean(latency_log));
fprintf('Total Collisions Detected: %d\n', collision_count);
fprintf('Total Packets Lost: %d\n', packets_lost);
fprintf('Total Retransmissions: %d\n', retransmission_count);

%% Function to Simulate Message Transmission
function [throughput, latency_log, packets_lost, retransmission_count] = send_message(sender, receiver, message_content, positions, hub_position, packet_loss_probability, latency, throughput, latency_log, packets_lost, protocol_type, timeout, retransmission_count)
    max_retries = 3; % Maximum number of retransmission attempts
    retry_count = 0;

    while retry_count <= max_retries
        % Simulate Packet Loss
        if rand > packet_loss_probability
            % Simulate Latency
            pause(latency);

            % Log Performance Metrics
            throughput(receiver) = throughput(receiver) + 1;
            latency_log = [latency_log; latency];

            % Visualize Message Transmission
            fprintf('📡 Robot %d sends message to Robot %d: "%s"\n', sender, receiver, message_content);

            % Show message at sender
            msg_display = text(positions(sender, 1), positions(sender, 2) - 0.5, message_content, ...
                'FontSize', 12, 'Color', 'red', 'HorizontalAlignment', 'center');
            pause(0.1);

            % Draw transmission line from sender to hub
            line([positions(sender, 1), hub_position(1)], [positions(sender, 2), hub_position(2)], 'Color', 'red');
            pause(0.1);

            % Hub relays message
            hub_msg = text(hub_position(1), hub_position(2) - 0.5, 'Relaying...', ...
                'FontSize', 12, 'Color', 'blue', 'HorizontalAlignment', 'center');
            pause(0.1);

            % Draw transmission line from hub to receiver
            line([hub_position(1), positions(receiver, 1)], [hub_position(2), positions(receiver, 2)], 'Color', 'green');
            pause(0.1);

            % Show received message at receiver
            received_msg = text(positions(receiver, 1), positions(receiver, 2) - 0.5, ...
                ['Received: ', message_content], 'FontSize', 12, 'FontWeight', 'bold', 'Color', 'green', 'HorizontalAlignment', 'center');
            pause(0.1);

            % Clear temporary messages
            delete(msg_display);
            delete(hub_msg);
            delete(received_msg);

            % Simulate Acknowledgment (for TCP-like protocol)
            if strcmp(protocol_type, 'TCP')
                fprintf('✅ Robot %d acknowledges receipt of message from Robot %d\n', receiver, sender);
            end

            break; % Exit retry loop if message is successfully delivered
        else
            % Packet is lost
            fprintf('❌ Packet lost from Robot %d to Robot %d\n', sender, receiver);
            packets_lost = packets_lost + 1;

            % Retransmit if using TCP-like protocol
            if strcmp(protocol_type, 'TCP') && retry_count < max_retries
                retry_count = retry_count + 1;
                retransmission_count = retransmission_count + 1;
                fprintf('🔄 Retransmitting message from Robot %d to Robot %d (Attempt %d)\n', sender, receiver, retry_count);
                pause(timeout); % Simulate timeout before retransmission
            else
                break; % Exit retry loop if max retries reached
            end
        end
    end
end