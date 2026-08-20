function [predictedClass, actualClass, scores] = train_eval_generic(X, y, hiddenSize)

arguments (Input)
    X double
    y double
    hiddenSize (1,1) double {mustBePositive}
end

arguments (Output)
    predictedClass double
    actualClass double
    scores double
end

inputs = X';
targets = zeros(2, numel(y));
targets(1, y==1) = 1;
targets(2, y==0) = 1;

net = patternnet(hiddenSize);
net.trainParam.showWindow = false;
[net, tr] = train(net, inputs, targets);

outputs = net(inputs);
predictedAll = vec2ind(outputs);
actualAll = vec2ind(targets);

testIdx = tr.testInd;
predictedClass = predictedAll(testIdx);
actualClass = actualAll(testIdx);
scores = outputs(1, testIdx);

end
