%% RATE MONOTONIC SCHEDULING (p(P1) > p(P2) > p(P3))
clear
close all 
clc 

% Task: [ID, Costo(C), Periodo(T)]
tasks = [
    1, 2, 6;    % P1
    2, 2, 12;   % P2
    3, 8, 24    % P3
];

n_tasks = size(tasks, 1);
IDs = tasks(:, 1);
Cs  = tasks(:, 2);
Ts  = tasks(:, 3);

MCT = 24; 
time_step = 1; 

rem_capacity = zeros(n_tasks, 1);   
next_release = zeros(n_tasks, 1);   
schedule_log = zeros(MCT, 1);       

for t = 1:MCT
    current_time = t - 1;
    
    for i = 1:n_tasks
        if current_time == next_release(i)
            rem_capacity(i) = Cs(i);           
            next_release(i) = next_release(i) + Ts(i); 
        end
    end
    
    active_task_idx = -1;
    for i = 1:n_tasks
        if rem_capacity(i) > 0
            active_task_idx = i;
            break;
        end
    end
    
    if active_task_idx ~= -1
        rem_capacity(active_task_idx) = rem_capacity(active_task_idx) - 1;
        schedule_log(t) = tasks(active_task_idx, 1); 
    else
        schedule_log(t) = 0; % IDLE
    end
    
    for i = 1:n_tasks
        if rem_capacity(i) > 0 && current_time + 1 == next_release(i)
           fprintf('CRITICAL: Deadline Miss per Task P%d al tempo %d!\n', tasks(i,1), current_time+1);
        end
    end
end

figure;
hold on; grid on;

color_map = containers.Map([1, 2, 3], {[0 0.4470 0.7410], [0.8500 0.3250 0.0980], [0.9290 0.6940 0.1250]});

for t = 1:MCT
    tid = schedule_log(t);
    if tid > 0
        rectangle('Position', [t-1, tid-0.4, 1, 0.8], 'FaceColor', color_map(tid), 'EdgeColor', 'none');
    else
        rectangle('Position', [t-1, 0.5, 1, 3], 'FaceColor', [0.9 0.9 0.9], 'EdgeColor', 'none');
    end
end

for i = 1:n_tasks
    orig_id = tasks(i,1);
    period = tasks(i,3);
    for p = 0:period:MCT
        text(p, orig_id+0.45, '\downarrow', 'HorizontalAlignment', 'center', 'FontSize', 10, 'FontWeight', 'bold');
        if p > 0 && p < MCT
             xline(p, ':', 'Color', [0.5 0.5 0.5], 'LineWidth', 0.5);
        end
    end
end

title('Rate Monotonic (RM)');
xlabel('Tempo [ms]');
ylabel('Task ID');
set(gca, 'YTick', 1:3, 'YTickLabel', {'P_1', 'P_2', 'P_3'});
xticks(0:2:MCT);
xlim([0 MCT]);
ylim([0.5 3.5]);
