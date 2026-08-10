function [eer, thresholds, farCurve, frrCurve] = compute_eer(scores, labels)

arguments (Input)
    scores double
    labels double
end

arguments (Output)
    eer double
    thresholds double
    farCurve double
    frrCurve double
end

thresholds = 0:0.01:1;
farCurve = zeros(size(thresholds));
frrCurve = zeros(size(thresholds));

for i = 1:numel(thresholds)
    predictedGenuine = scores >= thresholds(i);
    farCurve(i) = sum(predictedGenuine & labels==2) / sum(labels==2);
    frrCurve(i) = sum(~predictedGenuine & labels==1) / sum(labels==1);
end

[~, crossIdx] = min(abs(farCurve - frrCurve));
eer = (farCurve(crossIdx) + frrCurve(crossIdx)) / 2;

end