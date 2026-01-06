%% EARLIEST DEADLINE FIRST (EDF)
clear
clc
close all

% Task:[ID, Costo(C), Periodo(T)]
tasks = [
    1, 2, 6;    % P1
    2, 2, 12;   % P2
    3, 8, 24    % P3
];

num_tasks = size(tasks, 1);
IDs = tasks(:, 1);
Cs  = tasks(:, 2);
Ts  = tasks(:, 3);
MCT = 24; 

remaining_time = zeros(num_tasks, 1);
absolute_deadline = inf(num_tasks, 1); 
history_log = zeros(1, MCT);

for t = 1:MCT
    current_time = t - 1;
    
    for i = 1:num_tasks
        period = tasks(i, 3);
        cost = tasks(i, 2);
        
        if mod(current_time, period) == 0
            remaining_time(i) = remaining_time(i) + cost;
            absolute_deadline(i) = current_time + period;
        end
    end
    
    min_deadline = inf;
    active_task_idx = 0;
    
    for i = 1:num_tasks
        if remaining_time(i) > 0
            if absolute_deadline(i) < min_deadline
                min_deadline = absolute_deadline(i);
                active_task_idx = i;
            elseif absolute_deadline(i) == min_deadline
                if active_task_idx == 0 || i < active_task_idx
                     active_task_idx = i;
                end
            end
        end
    end
    
    if active_task_idx > 0
        history_log(t) = tasks(active_task_idx, 1);
        remaining_time(active_task_idx) = remaining_time(active_task_idx) - 1;
        
        if remaining_time(active_task_idx) == 0
            absolute_deadline(active_task_idx) = inf;
        end
    else
        history_log(t) = 0; 
    end
end

figure;
hold on; grid on;

color_map = containers.Map([1, 2, 3], {[0 0.4470 0.7410], [0.8500 0.3250 0.0980], [0.9290 0.6940 0.1250]});

for t = 1:MCT
    tid = history_log(t);
    if tid > 0
        rectangle('Position', [t-1, tid-0.4, 1, 0.8], 'FaceColor', color_map(tid), 'EdgeColor', 'none');
    else
        
        rectangle('Position', [t-1, 0.5, 1, 3], 'FaceColor', [0.9 0.9 0.9], 'EdgeColor', 'none');
    end
end

for i = 1:num_tasks
    orig_id = tasks(i,1);
    period = tasks(i,3);
    for p = 0:period:MCT
        text(p, orig_id+0.45, '\downarrow', 'HorizontalAlignment', 'center', 'FontSize', 10, 'FontWeight', 'bold');
       
        if p > 0 && p < MCT
             xline(p, ':', 'Color', [0.5 0.5 0.5], 'LineWidth', 0.5);
        end
    end
end

title('Earliest Deadline First (EDF) Scheduling');
xlabel('Tempo [ms]');
ylabel('Task ID');
set(gca, 'YTick', 1:3, 'YTickLabel', {'P_1', 'P_2', 'P_3'});
xticks(0:2:MCT);  
xlim([0 MCT]);
ylim([0.5 3.5]);
