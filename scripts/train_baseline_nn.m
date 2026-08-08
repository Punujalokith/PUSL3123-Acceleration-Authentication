load_dataset;

[X, y] = make_genuine_impostor_set(data, 3, 4);

inputs = X';

targets = zeros(2, numel(y));
targets(1, y==1) = 1;
targets(2, y==0) = 1;

net = patternnet(10);
[net, tr] = train(net, inputs, targets);

outputs = net(inputs);
predictedClass = vec2ind(outputs);
actualClass = vec2ind(targets);

testIdx = tr.testInd;

testAccuracy = mean(predictedClass(testIdx) == actualClass(testIdx));

fprintf('Held-out test accuracy for User 3: %.2f%% (n=%d test samples)\n', ...
    testAccuracy*100, numel(testIdx));

actualTest = actualClass(testIdx);
predTest = predictedClass(testIdx);

FRR = sum(actualTest==1 & predTest==2) / sum(actualTest==1);
FAR = sum(actualTest==2 & predTest==1) / sum(actualTest==2);

fprintf('FRR: %.2f%%   FAR: %.2f%%\n', FRR*100, FAR*100);