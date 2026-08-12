load_dataset;

feat = 1;
u1_samples = data.U01.TimeD_FreqD_FDay(:, feat);

figure;
plot(u1_samples, 'o-');
xlabel('Sample');
ylabel(sprintf('Feature %d value', feat));
title(sprintf('User 1 — Feature %d across their 36 samples', feat));
grid on;

all_users_feat = zeros(36, 10);
for u = 1:10
    uid = sprintf('U%02d', u);
    all_users_feat(:, u) = data.(uid).TimeD_FreqD_FDay(:, feat);
end

figure;
plot(all_users_feat);
xlabel('Sample');
ylabel(sprintf('Feature %d value', feat));
title(sprintf('Feature %d across all 10 users', feat));
legend(string(1:10));
grid on;

means_per_user = mean(all_users_feat, 1);
stds_per_user  = std(all_users_feat, 0, 1);

figure;
errorbar(1:10, means_per_user, stds_per_user, 'o', 'LineWidth', 1.5, 'MarkerSize', 8);
xlabel('User');
ylabel(sprintf('Feature %d value', feat));
title(sprintf('Feature %d: mean per user (dot) with intra-user spread (bar)', feat));
xticks(1:10);
grid on;



nFeat = 131;
scores = zeros(nFeat, 1);

for f = 1:nFeat
    vals = zeros(36, 10);
    for u = 1:10
        uid = sprintf('U%02d', u);
        vals(:, u) = data.(uid).TimeD_FreqD_FDay(:, f);
    end
    user_means = mean(vals, 1);
    user_stds  = std(vals, 0, 1);

    interVar = var(user_means);
    intraVar = mean(user_stds.^2);

    scores(f) = interVar / intraVar;
end

validIdx = ~isnan(scores);
fprintf('%d of %d features are constant/invalid and excluded.\n', sum(~validIdx), nFeat);
disp('Excluded feature indices:'); disp(find(~validIdx)');

validScores = scores(validIdx);
validFeat = find(validIdx);
[sortedScores, order] = sort(validScores, 'descend');
rankedFeat = validFeat(order);

figure;
bar(sortedScores);
xlabel('Feature (ranked)');
ylabel('Separability score');
title('Feature separability, best to worst');

disp('Top 10 most discriminative features:');
disp(rankedFeat(1:10)');
disp('Their scores:');
disp(sortedScores(1:10)');

save('D:\Assingments\03) Refferals Coursework (AIML)\02) Project\results\feature_ranking.mat', 'rankedFeat', 'sortedScores');
