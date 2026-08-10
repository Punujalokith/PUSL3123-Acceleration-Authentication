load_dataset;

nUsers = 10;
nRepeats = 5;

accAll = zeros(nUsers, nRepeats);
farAll = zeros(nUsers, nRepeats);
frrAll = zeros(nUsers, nRepeats);

allScores = [];
allLabels = [];

for u = 1:nUsers
    for r = 1:nRepeats
        [acc, far, frr, scores, labels] = train_and_evaluate_user(data, u, 4, 10);

        accAll(u,r) = acc;
        farAll(u,r) = far;
        frrAll(u,r) = frr;

        allScores = [allScores, scores];
        allLabels = [allLabels, labels];
     
    end
    fprintf('User %d done (%d/%d)\n', u, u, nUsers);
end

meanAcc = mean(accAll, 2);
meanFAR = mean(farAll, 2, 'omitnan');
meanFRR = mean(frrAll, 2, 'omitnan');

resultsTable = table((1:10)', meanAcc*100, meanFAR*100, meanFRR*100, ...
    'VariableNames', {'User','Accuracy_pct','FAR_pct','FRR_pct'})

fprintf('\nOVERALL across all users: acc=%.2f%%  FAR=%.2f%%  FRR=%.2f%%\n', ...
    mean(meanAcc)*100, mean(meanFAR,'omitnan')*100, mean(meanFRR,'omitnan')*100);

[eer, thresholds, farCurve, frrCurve] = compute_eer(allScores, allLabels);

fprintf('Overall EER (pooled across all users/repeats): %.2f%%\n', eer*100);

figure;
plot(thresholds, farCurve, 'r-', thresholds, frrCurve, 'b-', 'LineWidth', 1.5);
xlabel('Decision threshold');
ylabel('Error rate');
legend('FAR', 'FRR');
title(sprintf('FAR/FRR vs threshold (EER = %.2f%%)', eer*100));
grid on;