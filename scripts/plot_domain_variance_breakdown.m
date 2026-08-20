load_all_domains;

domains = struct('key', {'TimeD_FDay', 'FreqD_FDay'}, ...
    'label', {'Time Domain (TD)', 'Frequency Domain (FD)'}, ...
    'nFeat', {88, 43}, ...
    'fileTag', {'TD', 'FD'});

nUsers = 10;

for di = 1:numel(domains)
    dom = domains(di);
    nFeat = dom.nFeat;

    allVals = zeros(36, nUsers, nFeat);
    for u = 1:nUsers
        uid = sprintf('U%02d', u);
        allVals(:, u, :) = allData.(uid).(dom.key);
    end

    intraVar = zeros(nUsers, nFeat);
    for u = 1:nUsers
        intraVar(u, :) = var(squeeze(allVals(:, u, :)), 0, 1);
    end
    stdDev = sqrt(intraVar);

    userMeans = zeros(nUsers, nFeat);
    for u = 1:nUsers
        userMeans(u, :) = mean(squeeze(allVals(:, u, :)), 1);
    end
    interVar = var(userMeans, 0, 1);

    figure('Position', [100 60 800 750]);

    subplot(3,1,1);
    hold on;
    for u = 1:nUsers
        plot(1:nFeat, intraVar(u,:), 'LineWidth', 0.9);
    end
    plot(1:nFeat, mean(intraVar,1), 'k--', 'LineWidth', 1.6);
    hold off;
    title(sprintf('%s Intra-variance (Low is good)', dom.label));
    xlabel('Feature Index'); ylabel('Variance');
    legend([strcat('U', string(1:nUsers)), "Mean"], 'Location', 'eastoutside', 'FontSize', 7);
    grid on;

    subplot(3,1,2);
    hold on;
    for u = 1:nUsers
        plot(1:nFeat, stdDev(u,:), 'LineWidth', 0.9);
    end
    plot(1:nFeat, mean(stdDev,1), 'k--', 'LineWidth', 1.6);
    hold off;
    title(sprintf('%s Standard Deviation', dom.label));
    xlabel('Feature Index'); ylabel('Std. Dev.');
    grid on;

    subplot(3,1,3);
    plot(1:nFeat, interVar, 'r-', 'LineWidth', 1.4);
    title(sprintf('%s Inter-variance (High is good)', dom.label));
    xlabel('Feature Index'); ylabel('Variance');
    grid on;

    outFile = sprintf('D:\\Assingments\\03) Refferals Coursework (AIML)\\02) Project\\report\\graphs\\domain_variance_%s_01.png', dom.fileTag);
    saveas(gcf, outFile);
    fprintf('Saved figure: domain_variance_%s_01.png\n', dom.fileTag);
end
