%% STATIC CYCLIC SCHEDULING (SCS)
clear
close all
clc

% Task: [ID, Costo(C), Periodo(T)] ------- Deadline D assunta uguale a T
tasks = [
    1, 2, 6;    % P1
    2, 2, 12;   % P2
    3, 8, 24    % P3
];


MCT = 24;       
mct = 6;        
num_frames = MCT / mct; 

schedule_table = cell(num_frames, 1);

schedule_table{1} = [1, 2; 2, 2]; 
schedule_table{2} = [1, 2; 3, 4]; 
schedule_table{3} = [1, 2; 2, 2]; 
schedule_table{4} = [1, 2; 3, 4]; 


% Plot
figure
hold on; grid on;

task_colors = [0 0.4470 0.7410; 0.8500 0.3250 0.0980; 0.9290 0.6940 0.1250];

for f = 1:num_frames
    t_start_frame = (f-1) * mct;
    t_end_frame = t_start_frame + mct;
    t_current = t_start_frame;
    
    jobs = schedule_table{f};
        
    if isempty(jobs)
        fprintf('IDLE Completamente');
    else
        
        for i = 1:size(jobs, 1)
            tid = jobs(i, 1);      
            duration = jobs(i, 2); 
                    
            rectangle('Position', [t_current, tid-0.4, duration, 0.8], 'FaceColor', task_colors(tid,:), 'EdgeColor', 'none');
            
            t_current = t_current + duration;
        end
    end
    
    
    if t_current < t_end_frame
        idle_dt = t_end_frame - t_current;
        rectangle('Position', [t_current, 0.5, idle_dt, 3], 'FaceColor', [0.9 0.9 0.9], 'EdgeColor', 'none');
        text(t_current + idle_dt/2, 0.7, 'Idle', 'HorizontalAlignment', 'center', 'Color', [0.5 0.5 0.5], 'FontSize', 8);
             
    end
    
    xline(t_end_frame, '--r', 'LineWidth', 1.5, 'Alpha', 0.6);
end


title(sprintf('Static Cyclic Scheduling (MCT=%d, mct=%d)', MCT, mct));
xlabel('Tempo [ms]');
ylabel('Task ID');
set(gca, 'YTick', 1:3, 'YTickLabel', {'P_1', 'P_2 ', 'P_3'});
xticks(0:mct:MCT); 
xlim([0 MCT]);
ylim([0.5 3.5]);
