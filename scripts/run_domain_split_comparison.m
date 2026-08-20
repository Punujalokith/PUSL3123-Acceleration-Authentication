load_all_domains;

domains = {'TimeD_FreqD', 'TimeD', 'FreqD'};
domainLabels = {'TimeD+FreqD', 'TimeD', 'FreqD'};
splits = {'SameDay', 'CrossDay', 'Combined'};
nUsers = 10;
nRepeats = 5;
hiddenSize = 10;
nImpostorPerOther = 4;

results = struct();
rowNames = {};
rowData = [];

for di = 1:numel(domains)
    domain = domains{di};
    fdayField = sprintf('%s_FDay', domain);
    mdayField = sprintf('%s_MDay', domain);

    for si = 1:numel(splits)
        split = splits{si};

        allScores = [];
        allActual = [];

        for u = 1:nUsers
            for r = 1:nRepeats
                switch split
                    case 'SameDay'
                        [X, y] = build_domain_impostor_set(allData, u, nImpostorPerOther, fdayField);
                        [~, actualClass, scores] = train_eval_generic(X, y, hiddenSize);
                    case 'CrossDay'
                        [Xtrain, ytrain] = build_domain_impostor_set(allData, u, nImpostorPerOther, fdayField);
                        [Xtest, ytest] = build_domain_impostor_set(allData, u, nImpostorPerOther, mdayField);
                        [~, actualClass, scores] = train_eval_crossday(Xtrain, ytrain, Xtest, ytest, hiddenSize);
                    case 'Combined'
                        [X1, y1] = build_domain_impostor_set(allData, u, nImpostorPerOther, fdayField);
                        [X2, y2] = build_domain_impostor_set(allData, u, nImpostorPerOther, mdayField);
                        X = [X1; X2];
                        y = [y1; y2];
                        [~, actualClass, scores] = train_eval_generic(X, y, hiddenSize);
                end
                allScores = [allScores, scores];
                allActual = [allActual, actualClass];
            end
        end

        metrics = compute_full_metrics(allScores, allActual);
        key = sprintf('%s_%s', domain, split);
        results.(key) = metrics;

        rowNames{end+1} = key;
        rowData(end+1, :) = [metrics.Accuracy, metrics.Precision, metrics.Recall, ...
            metrics.Specificity, metrics.F1, metrics.MCC, metrics.FAR, metrics.FRR, ...
            metrics.EER, metrics.AUC];

        fprintf('%-22s / %-9s: Acc=%.2f%% Prec=%.2f%% Rec=%.2f%% Spec=%.2f%% F1=%.2f%% MCC=%.3f FAR=%.2f%% FRR=%.2f%% EER=%.2f%% AUC=%.4f\n', ...
            domain, split, metrics.Accuracy*100, metrics.Precision*100, metrics.Recall*100, ...
            metrics.Specificity*100, metrics.F1*100, metrics.MCC, metrics.FAR*100, metrics.FRR*100, ...
            metrics.EER*100, metrics.AUC);
    end
end

summaryTable = array2table(rowData, 'VariableNames', ...
    {'Accuracy','Precision','Recall','Specificity','F1','MCC','FAR','FRR','EER','AUC'}, ...
    'RowNames', rowNames)

save('D:\Assingments\03) Refferals Coursework (AIML)\02) Project\results\domain_split_comparison.mat', ...
    'results', 'rowNames', 'rowData');

figure('Position', [100 100 1000 600]);
accByDomain = reshape(rowData(:,1), 3, 3)' * 100;  % rows=domain, cols=split
eerByDomain = reshape(rowData(:,9), 3, 3)' * 100;

subplot(1,2,1);
bar(accByDomain);
set(gca, 'XTickLabel', domainLabels, 'TickLabelInterpreter', 'none');
ylabel('Accuracy (%)');
legend(splits, 'Location', 'southoutside');
title('Accuracy by domain and split strategy');
grid on;

subplot(1,2,2);
bar(eerByDomain);
set(gca, 'XTickLabel', domainLabels, 'TickLabelInterpreter', 'none');
ylabel('EER (%)');
legend(splits, 'Location', 'southoutside');
title('EER by domain and split strategy');
grid on;

saveas(gcf, 'D:\Assingments\03) Refferals Coursework (AIML)\02) Project\report\graphs\domain_split_comparison_01.png');
fprintf('Saved figure: domain_split_comparison_01.png\n');
