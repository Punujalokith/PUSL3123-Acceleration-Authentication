function ratioResults = run_ratio_sweep_domain(allData, domain)

arguments (Input)
    allData (1,1) struct
    domain (1,:) char
end

arguments (Output)
    ratioResults table
end

fdayField = sprintf('%s_FDay', domain);

nImpostorPerOtherList = [4, 8, 12, 16, 20, 24, 28];
ratioLabels = {'1:1', '1:2', '1:3', '1:4', '1:5', '1:6', '1:7'};

nUsers = 10;
nRepeats = 5;
hiddenSize = 10;

rowData = zeros(numel(nImpostorPerOtherList), 10);
trainSizeList = zeros(numel(nImpostorPerOtherList), 1);
targetSamplesList = zeros(numel(nImpostorPerOtherList), 1);
imposterSamplesList = zeros(numel(nImpostorPerOtherList), 1);
testSizeList = zeros(numel(nImpostorPerOtherList), 1);

for ri = 1:numel(nImpostorPerOtherList)
    nImpostorPerOther = nImpostorPerOtherList(ri);

    allScores = [];
    allActual = [];
    testSizes = [];

    for u = 1:nUsers
        for r = 1:nRepeats
            [X, y] = build_domain_impostor_set(allData, u, nImpostorPerOther, fdayField);
            [~, actualClass, scores] = train_eval_generic(X, y, hiddenSize);
            allScores = [allScores, scores];
            allActual = [allActual, actualClass];
            testSizes(end+1) = numel(actualClass);
        end
    end

    metrics = compute_full_metrics(allScores, allActual);
    rowData(ri, :) = [metrics.Accuracy, metrics.Precision, metrics.Recall, ...
        metrics.Specificity, metrics.F1, metrics.MCC, metrics.FAR, metrics.FRR, ...
        metrics.EER, metrics.AUC];

    targetSamplesList(ri) = 36;
    imposterSamplesList(ri) = nImpostorPerOther * 9;
    trainSizeList(ri) = targetSamplesList(ri) + imposterSamplesList(ri);
    testSizeList(ri) = round(mean(testSizes));
end

ratioResults = array2table(rowData, 'VariableNames', ...
    {'Accuracy','Precision','Recall','Specificity','F1','MCC','FAR','FRR','EER','AUC'}, ...
    'RowNames', ratioLabels);
ratioResults.TrainingSetSize = trainSizeList;
ratioResults.TargetSamples = targetSamplesList;
ratioResults.ImposterSamples = imposterSamplesList;
ratioResults.MeanTestSetSize = testSizeList;

fprintf('\n=== Ratio-Based Performance for %s Domain (SameDay/FDay, %d repeats/user) ===\n', ...
    strrep(domain, '_', '+'), nRepeats);
printable = ratioResults;
pct = {'Accuracy','Precision','Recall','Specificity','F1','FAR','FRR','EER'};
for i = 1:numel(pct)
    printable.(pct{i}) = printable.(pct{i}) * 100;
end
disp(printable);

end
