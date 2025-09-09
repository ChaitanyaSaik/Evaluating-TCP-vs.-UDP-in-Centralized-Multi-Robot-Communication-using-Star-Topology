clc; clear; close all;

num_robots = 6; 
hub_id = num_robots + 1;
angles = linspace(0, 2*pi, num_robots+1); 
radius = 3;
positions = [radius * cos(angles(1:end-1)) + 4, 4;
             radius * sin(angles(1:end-1)) + 4, 4]';
hub_position = [4, 4];

fig = figure('Name', 'Robot Communication', 'NumberTitle', 'off', 'Position', [100, 100, 800, 400]);
axis([0 8 0 8]); hold on; grid on;
title('Robot Communication with Star Topology');

for i = 1:num_robots
    text(positions(i, 1), positions(i, 2), '🤖', 'FontSize', 20, 'HorizontalAlignment', 'center', 'Color', 'black');
    text(positions(i, 1), positions(i, 2) + 0.3, sprintf('Robot %d', i), 'FontSize', 12, 'HorizontalAlignment', 'center', 'Color', 'black');
end
text(hub_position(1), hub_position(2), '📡', 'FontSize', 20, 'HorizontalAlignment', 'center', 'Color', 'blue');
text(hub_position(1), hub_position(2) + 0.3, 'Hub', 'FontSize', 12, 'HorizontalAlignment', 'center', 'Color', 'red');

for i = 1:num_robots
    line([positions(i, 1), hub_position(1)], [positions(i, 2), hub_position(2)], 'Color', 'blue', 'LineStyle', '--');
end

function send_message(sender, receiver, message_content, positions, hub_position)
    fprintf('📡 Robot %d sends message to Robot %d: "%s"\n', sender, receiver, message_content);
    pause(0.5);
    text(positions(sender, 1), positions(sender, 2) - 0.5, message_content, 'FontSize', 12, 'Color', 'red', 'HorizontalAlignment', 'center');
    pause(1);
    line([positions(sender, 1), hub_position(1)], [positions(sender, 2), hub_position(2)], 'Color', 'red');
    pause(1);
    text(hub_position(1), hub_position(2) - 0.5, 'Relaying...', 'FontSize', 12, 'Color', 'blue', 'HorizontalAlignment', 'center');
    pause(1);
    line([hub_position(1), positions(receiver, 1)], [hub_position(2), positions(receiver, 2)], 'Color', 'green');
    pause(1);
    text(positions(receiver, 1), positions(receiver, 2) - 0.5, ['Final message: ', message_content], 'FontSize', 12, 'FontWeight', 'bold', 'Color', 'green', 'HorizontalAlignment', 'center');
    pause(1);
end

fprintf('Choose a condition to simulate:\n');
fprintf('1. Robot 1 sends a message → Hub → All Robots 2-6 (Simultaneously).\n');
fprintf('2. Robots 1-5 send messages → Hub → Robot 6 (Collected & Sent Based on Acknowledgement).\n');
choice = input('Enter your choice (1 or 2): ');

if choice == 1
    message_content = 'Hello, Robots!';
    for dest = 2:6
        send_message(1, dest, message_content, positions, hub_position);
    end
elseif choice == 2
    messages = {'Msg1', 'Msg2', 'Msg3', 'Msg4', 'Msg5'};
    fprintf('All Robots 1-5 sent messages to the hub. Waiting for acknowledgement from Robot 6...\n');
    pause(2);
    acknowledged_sender = input('Robot 6, enter the sender number you want to receive a message from (1-5): ');
    if acknowledged_sender >= 1 && acknowledged_sender <= 5
        send_message(acknowledged_sender, 6, messages{acknowledged_sender}, positions, hub_position);
        fprintf('Message from Robot %d delivered to Robot 6. Now sending all remaining messages...\n', acknowledged_sender);
        for i = 1:5
            if i ~= acknowledged_sender
                send_message(i, 6, messages{i}, positions, hub_position);
            end
        end
        fprintf('All messages delivered to Robot 6.\n');
    else
        disp('Invalid sender selection! No message sent.');
    end
else
    disp('Invalid choice!');
end