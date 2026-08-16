load_dataset;
load('D:\Assingments\03) Refferals Coursework (AIML)\02) Project\results\feature_ranking.mat');

featureIdx40 = rankedFeat(1:40);

for h = [10, 20]

    accAll = zeros(10,10);
    farAll = zeros(10,10);
    frrAll = zeros(10,10);

    allScores = [];
    allLabels = [];

    for u = 1:10
        for r = 1:10

            [acc, far, frr, scores, labels] = ...
                train_and_evaluate_user(data, u, 4, h, featureIdx40);

            accAll(u,r) = acc;
            farAll(u,r) = far;
            frrAll(u,r) = frr;

            allScores = [allScores, scores];
            allLabels = [allLabels, labels];

        end
    end

    eerH = compute_eer(allScores, allLabels);

    meanAccuracy = mean(accAll(:)) * 100;
    stdAccuracy = std(accAll(:)) * 100;
    meanFAR = mean(farAll(:), 'omitnan') * 100;
    meanFRR = mean(frrAll(:), 'omitnan') * 100;

    fprintf(['hidden=%d CONFIRMED (n=10 repeats): ' ...
        'acc=%.2f%% +/- %.2f  FAR=%.2f%%  FRR=%.2f%%  EER=%.2f%%\n'], ...
        h, meanAccuracy, stdAccuracy, meanFAR, meanFRR, eerH*100);

end