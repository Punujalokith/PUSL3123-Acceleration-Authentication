function [predictedClass, actualClass, scores] = train_eval_crossday(Xtrain, ytrain, Xtest, ytest, hiddenSize)

arguments (Input)
    Xtrain double
    ytrain double
    Xtest double
    ytest double
    hiddenSize (1,1) double {mustBePositive}
end

arguments (Output)
    predictedClass double
    actualClass double
    scores double
end

trainInputs = Xtrain';
trainTargets = zeros(2, numel(ytrain));
trainTargets(1, ytrain==1) = 1;
trainTargets(2, ytrain==0) = 1;

net = patternnet(hiddenSize);
net.trainParam.showWindow = false;
net.divideParam.trainRatio = 0.85;
net.divideParam.valRatio = 0.15;
net.divideParam.testRatio = 0;

net = train(net, trainInputs, trainTargets);

testInputs = Xtest';
testTargets = zeros(2, numel(ytest));
testTargets(1, ytest==1) = 1;
testTargets(2, ytest==0) = 1;

outputs = net(testInputs);
predictedClass = vec2ind(outputs);
actualClass = vec2ind(testTargets);
scores = outputs(1, :);

end
