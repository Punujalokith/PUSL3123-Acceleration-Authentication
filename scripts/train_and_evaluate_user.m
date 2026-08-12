function [testAccuracy, FAR, FRR, testScores, testLabels] = train_and_evaluate_user(data, targetUser, nImpostorPerOther, hiddenSize, featureIdx)

arguments (Input)
    data (1,1) struct
    targetUser (1,1) double {mustBeInRange(targetUser,1,10)}
    nImpostorPerOther (1,1) double {mustBePositive}
    hiddenSize (1,1) double {mustBePositive}
    featureIdx (1,:) double = 1:131
end

arguments (Output)
    testAccuracy double
    FAR double
    FRR double
    testScores double
    testLabels double
end

[X, y] = make_genuine_impostor_set(data, targetUser, nImpostorPerOther);

X = X(:, featureIdx);

inputs = X';
targets = zeros(2, numel(y));
targets(1, y==1) = 1;
targets(2, y==0) = 1;

net = patternnet(hiddenSize);
net.trainParam.showWindow = false;
[net, tr] = train(net, inputs, targets);

outputs = net(inputs);
predictedClass = vec2ind(outputs);
actualClass = vec2ind(targets);

testIdx = tr.testInd;
actualTest = actualClass(testIdx);
predTest = predictedClass(testIdx);

testAccuracy = mean(predTest == actualTest);
FRR = sum(actualTest==1 & predTest==2) / sum(actualTest==1);
FAR = sum(actualTest==2 & predTest==1) / sum(actualTest==2);

testScores = outputs(1, testIdx);
testLabels = actualTest;

end