load_all_domains;

domains = {'TimeD_FreqD', 'TimeD', 'FreqD'};
domainLabels = {'TimeD+FreqD', 'TimeD', 'FreqD'};
ratioLabels = {'1:1', '1:2', '1:3', '1:4', '1:5', '1:6', '1:7'};
ratioN = 1:7;

allResults = struct();
for di = 1:numel(domains)
    allResults.(domains{di}) = run_ratio_sweep_domain(allData, domains{di});
end

save('D:\Assingments\03) Refferals Coursework (AIML)\02) Project\results\ratio_sweep_all_domains.mat', 'allResults');

colors = {'b', 'r', 'g'};
markers = {'o', 's', '^'};

figure('Position', [80 60 900 950]);

metrics = {'Accuracy', 'MCC', 'FAR', 'FRR'};
titles = {'Accuracy vs Ratio', 'MCC vs Ratio', 'FAR vs Ratio', 'FRR vs Ratio'};
ylabels = {'Accuracy (%)', 'MCC', 'FAR (%)', 'FRR (%)'};

for mi = 1:4
    subplot(3, 2, mi);
    hold on;
    for di = 1:numel(domains)
        vals = allResults.(domains{di}).(metrics{mi});
        if ~strcmp(metrics{mi}, 'MCC')
            vals = vals * 100;
        end
        plot(ratioN, vals, ['-' markers{di}], 'Color', colors{di}, 'LineWidth', 1.4, 'MarkerSize', 6);
    end
    hold off;
    set(gca, 'XTick', ratioN, 'XTickLabel', ratioLabels);
    xlabel('Ratio (1:N)');
    ylabel(ylabels{mi});
    title(titles{mi});
    legend(domainLabels, 'Location', 'best');
    grid on;
end

subplot(3, 2, [5 6]);
hold on;
for di = 1:numel(domains)
    vals = allResults.(domains{di}).EER * 100;
    plot(ratioN, vals, ['-' markers{di}], 'Color', colors{di}, 'LineWidth', 1.4, 'MarkerSize', 6);
end
hold off;
set(gca, 'XTick', ratioN, 'XTickLabel', ratioLabels);
xlabel('Ratio (1:N)');
ylabel('EER (%)');
title('Equal Error Rate (EER) vs Ratio');
legend(domainLabels, 'Location', 'best');
grid on;

sgtitle('Performance Metrics Across Different Ratio Splits and Feature Sets');

saveas(gcf, 'D:\Assingments\03) Refferals Coursework (AIML)\02) Project\report\graphs\ratio_sweep_comparison_01.png');
fprintf('Saved figure: ratio_sweep_comparison_01.png\n');
