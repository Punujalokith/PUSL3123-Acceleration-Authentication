function metrics = compute_full_metrics(scores, actualClass)

arguments (Input)
    scores double
    actualClass double
end

arguments (Output)
    metrics struct
end

predictedClass = ones(size(scores));
predictedClass(scores < 0.5) = 2;

TP = sum(actualClass==1 & predictedClass==1);
FN = sum(actualClass==1 & predictedClass==2);
FP = sum(actualClass==2 & predictedClass==1);
TN = sum(actualClass==2 & predictedClass==2);

metrics.Accuracy    = (TP+TN) / (TP+TN+FP+FN);
metrics.Precision   = TP / max(TP+FP, 1);
metrics.Recall      = TP / max(TP+FN, 1);
metrics.Specificity = TN / max(TN+FP, 1);
metrics.F1          = 2*metrics.Precision*metrics.Recall / max(metrics.Precision+metrics.Recall, eps);

denom = sqrt((TP+FP)*(TP+FN)*(TN+FP)*(TN+FN));
if denom == 0
    metrics.MCC = 0;
else
    metrics.MCC = (TP*TN - FP*FN) / denom;
end

metrics.FAR = FP / max(FP+TN, 1);
metrics.FRR = FN / max(FN+TP, 1);

eer = compute_eer(scores, actualClass);
metrics.EER = eer;

thresholds = 0:0.01:1;
tpr = zeros(size(thresholds));
fpr = zeros(size(thresholds));
for i = 1:numel(thresholds)
    predGenuine = scores >= thresholds(i);
    tpr(i) = sum(predGenuine & actualClass==1) / sum(actualClass==1);
    fpr(i) = sum(predGenuine & actualClass==2) / sum(actualClass==2);
end
[fprSorted, order] = sort(fpr);
tprSorted = tpr(order);
metrics.AUC = trapz(fprSorted, tprSorted);

end
