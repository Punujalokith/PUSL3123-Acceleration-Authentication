function domainResults = run_single_domain_comparison(allData, domain)

arguments (Input)
    allData (1,1) struct
    domain (1,:) char
end

arguments (Output)
    domainResults table
end

splits = {'SameDay', 'CrossDay', 'Combined'};
nUsers = 10;
nRepeats = 5;
hiddenSize = 10;
nImpostorPerOther = 4;

fdayField = sprintf('%s_FDay', domain);
mdayField = sprintf('%s_MDay', domain);

rowData = zeros(numel(splits), 10);

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
    rowData(si, :) = [metrics.Accuracy, metrics.Precision, metrics.Recall, ...
        metrics.Specificity, metrics.F1, metrics.MCC, metrics.FAR, metrics.FRR, ...
        metrics.EER, metrics.AUC];
end

domainResults = array2table(rowData, 'VariableNames', ...
    {'Accuracy','Precision','Recall','Specificity','F1','MCC','FAR','FRR','EER','AUC'}, ...
    'RowNames', splits);

fprintf('\n=== %s Domain ===\n', strrep(domain, '_', '+'));
printable = domainResults;
pct = {'Accuracy','Precision','Recall','Specificity','F1','FAR','FRR','EER'};
for i = 1:numel(pct)
    printable.(pct{i}) = printable.(pct{i}) * 100;
end
disp(printable);

end
