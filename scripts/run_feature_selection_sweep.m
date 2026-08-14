load_dataset;
load('D:\Assingments\03) Refferals Coursework (AIML)\02) Project\results\feature_ranking.mat');

Ks = [10, 20, 40, 60, 90, 125];
nUsers = 10;
nRepeats = 3;   % fewer than the baseline's 5, to keep runtime reasonable for exploration

sweepResults = table('Size', [numel(Ks) 5], ...
    'VariableTypes', {'double','double','double','double','double'}, ...
    'VariableNames', {'K','MeanAcc','MeanFAR','MeanFRR','EER'});

for ki = 1:numel(Ks)
    K = Ks(ki);
    featureIdx = rankedFeat(1:K);

    accAll = zeros(nUsers, nRepeats);
    farAll = zeros(nUsers, nRepeats);
    frrAll = zeros(nUsers, nRepeats);
    allScores = [];
    allLabels = [];

    for u = 1:nUsers
        for r = 1:nRepeats
            [acc, far, frr, scores, labels] = train_and_evaluate_user(data, u, 4, 10, featureIdx);
            accAll(u,r) = acc;
            farAll(u,r) = far;
            frrAll(u,r) = frr;
            allScores = [allScores, scores];
            allLabels = [allLabels, labels];
        end
    end

    eerK = compute_eer(allScores, allLabels);

    sweepResults.K(ki) = K;
    sweepResults.MeanAcc(ki) = mean(accAll(:))*100;
    sweepResults.MeanFAR(ki) = mean(farAll(:), 'omitnan')*100;
    sweepResults.MeanFRR(ki) = mean(frrAll(:), 'omitnan')*100;
    sweepResults.EER(ki) = eerK*100;

    fprintf('K=%d done: acc=%.2f%% EER=%.2f%%\n', K, sweepResults.MeanAcc(ki), sweepResults.EER(ki));
end

sweepResults

figure;
plot(sweepResults.K, sweepResults.MeanAcc, 'o-', sweepResults.K, 100-sweepResults.EER, 's-', 'LineWidth', 1.5);
xlabel('Number of features (K)'); ylabel('%');
legend('Mean Accuracy', '100 - EER'); title('Performance vs number of features used');
grid on;