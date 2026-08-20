load('D:\Assingments\03) Refferals Coursework (AIML)\02) Project\results\head_to_head_comparison.mat');

% Use the optimized (K=40, hidden=20) configuration's pooled scores/labels
scores = allScoresByConfig{2};
labels = allLabelsByConfig{2};   % 1 = genuine, 2 = impostor

genuineScores = scores(labels == 1);
impostorScores = scores(labels == 2);

% --- Score distribution ---
figure;
histogram(genuineScores, 20, 'Normalization', 'probability', 'FaceAlpha', 0.6);
hold on;
histogram(impostorScores, 20, 'Normalization', 'probability', 'FaceAlpha', 0.6);
hold off;
xlabel('Network genuine-class output score');
ylabel('Proportion of test samples');
legend('Genuine', 'Impostor');
title('Distribution of classifier output scores (optimized model, K=40, hidden=20)');
grid on;
saveas(gcf, 'D:\Assingments\03) Refferals Coursework (AIML)\02) Project\report\graphs\score_distribution_01.png');
fprintf('Saved figure: score_distribution_01.png\n');

% --- ROC curve ---
thresholds = 0:0.01:1;
tpr = zeros(size(thresholds));
fpr = zeros(size(thresholds));
for i = 1:numel(thresholds)
    predictedGenuine = scores >= thresholds(i);
    tpr(i) = sum(predictedGenuine & labels==1) / sum(labels==1);   % true accept rate
    fpr(i) = sum(predictedGenuine & labels==2) / sum(labels==2);   % false accept rate
end
% Ensure monotonic order for trapz (thresholds descending => fpr ascending)
[fprSorted, order] = sort(fpr);
tprSorted = tpr(order);
aucVal = trapz(fprSorted, tprSorted);

figure;
plot(fpr, tpr, 'b-', 'LineWidth', 1.5);
hold on;
plot([0 1], [0 1], 'k--');
hold off;
xlabel('False Positive Rate (impostor accepted)');
ylabel('True Positive Rate (genuine accepted)');
title(sprintf('ROC curve, optimized model K=40, hidden=20 (AUC = %.4f)', aucVal));
grid on;
saveas(gcf, 'D:\Assingments\03) Refferals Coursework (AIML)\02) Project\report\graphs\roc_curve_01.png');
fprintf('Saved figure: roc_curve_01.png\n');
fprintf('AUC = %.4f\n', aucVal);
