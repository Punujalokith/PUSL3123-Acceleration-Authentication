load('D:\Assingments\03) Refferals Coursework (AIML)\02) Project\results\domain_split_comparison.mat');

domainLabels = {'TimeD+FreqD', 'TimeD', 'FreqD'};
splits = {'SameDay', 'CrossDay', 'Combined'};

% rowData columns: Accuracy, Precision, Recall, Specificity, F1, MCC, FAR, FRR, EER, AUC
farByDomain = reshape(rowData(:,7), 3, 3)' * 100;
frrByDomain = reshape(rowData(:,8), 3, 3)' * 100;
eerByDomain = reshape(rowData(:,9), 3, 3)' * 100;
accByDomain = reshape(rowData(:,1), 3, 3)' * 100;
f1ByDomain  = reshape(rowData(:,5), 3, 3)' * 100;

figure('Position', [80 60 1100 650]);

subplot(2,3,1);
bar(farByDomain);
set(gca, 'XTickLabel', domainLabels, 'TickLabelInterpreter', 'none');
ylabel('False Acceptance Rate (%)');
title('False Acceptance Rate');
grid on;

subplot(2,3,2);
bar(frrByDomain);
set(gca, 'XTickLabel', domainLabels, 'TickLabelInterpreter', 'none');
ylabel('False Rejection Rate (%)');
title('False Rejection Rate');
grid on;

subplot(2,3,3);
bar(eerByDomain);
set(gca, 'XTickLabel', domainLabels, 'TickLabelInterpreter', 'none');
ylabel('Equal Error Rate (%)');
title('Equal Error Rate');
grid on;

subplot(2,3,4);
bar(accByDomain);
set(gca, 'XTickLabel', domainLabels, 'TickLabelInterpreter', 'none');
ylabel('Accuracy (%)');
title('Accuracy');
grid on;

subplot(2,3,5);
bar(f1ByDomain);
set(gca, 'XTickLabel', domainLabels, 'TickLabelInterpreter', 'none');
ylabel('F1-score (%)');
title('F1-score');
grid on;

subplot(2,3,6);
hold on;
defaultColors = [0 0.4470 0.7410; 0.8500 0.3250 0.0980; 0.9290 0.6940 0.1250];
legendHandles = gobjects(1,3);
for i = 1:3
    legendHandles(i) = bar(nan, nan, 'FaceColor', defaultColors(i,:));
end
hold off;
axis off;
legend(legendHandles, splits, 'Location', 'north', 'Box', 'off', 'FontSize', 11);
title('Legend: evaluation protocol', 'FontWeight', 'normal');

sgtitle('Performance Across Domains and Evaluation Protocols');

saveas(gcf, 'D:\Assingments\03) Refferals Coursework (AIML)\02) Project\report\graphs\domain_split_comparison_01.png');
fprintf('Saved figure: domain_split_comparison_01.png\n');
