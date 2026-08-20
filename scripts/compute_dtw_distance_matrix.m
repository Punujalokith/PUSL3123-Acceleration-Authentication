load_dataset;

nUsers = 10;
dtwMatrix = zeros(nUsers, nUsers);

for i = 1:nUsers
    uidI = sprintf('U%02d', i);
    seqI = data.(uidI).TimeD_FreqD_FDay;   % 36 samples x 131 features
    for j = 1:nUsers
        if j < i
            dtwMatrix(i,j) = dtwMatrix(j,i);
            continue
        end
        uidJ = sprintf('U%02d', j);
        seqJ = data.(uidJ).TimeD_FreqD_FDay;
        dtwMatrix(i,j) = dtw(seqI, seqJ);
    end
end

save('D:\Assingments\03) Refferals Coursework (AIML)\02) Project\results\dtw_distance_matrix.mat', 'dtwMatrix');

figure('Position', [100 100 700 600]);
imagesc(dtwMatrix);
colormap(jet);
colorbar;
axis square;
set(gca, 'XTick', 1:nUsers, 'YTick', 1:nUsers);
xlabel('User Index');
ylabel('User Index');
title('DTW Distance Matrix (Acc TimeD FreqD Features)', 'Interpreter', 'none');

for i = 1:nUsers
    for j = 1:nUsers
        textColor = 'w';
        if dtwMatrix(i,j) > max(dtwMatrix(:)) * 0.55
            textColor = 'k';
        end
        text(j, i, sprintf('%.2f', dtwMatrix(i,j)), ...
            'HorizontalAlignment', 'center', 'Color', textColor, 'FontSize', 8);
    end
end

saveas(gcf, 'D:\Assingments\03) Refferals Coursework (AIML)\02) Project\report\graphs\dtw_distance_matrix_01.png');
fprintf('Saved figure: dtw_distance_matrix_01.png\n');

disp('DTW distance matrix:');
disp(array2table(dtwMatrix, 'VariableNames', strcat('U', string(1:nUsers)), ...
    'RowNames', strcat('U', string(1:nUsers))));
