load_dataset;

nImpostorPerOther = 4;
hiddenSize = 10;
nRepeats = 10;

[X, y] = make_genuine_impostor_set(data, 1, nImpostorPerOther);
inputs = X';
targets = zeros(2, numel(y));
targets(1, y==1) = 1;
targets(2, y==0) = 1;

trainTimes = zeros(1, nRepeats);
throughputs = zeros(1, nRepeats);
memUsages = zeros(1, nRepeats);

for r = 1:nRepeats
    net = patternnet(hiddenSize);
    net.trainParam.showWindow = false;

    infoBefore = whos('net');
    tStart = tic;
    [net, tr] = train(net, inputs, targets);
    trainTimes(r) = toc(tStart);
    infoAfter = whos('net');

    memUsages(r) = infoAfter.bytes / 1e6;   % MB
    throughputs(r) = numel(y) / trainTimes(r);
end

fprintf('\n==== Neural Network Architecture ====\n');
fprintf('Input Layer: %d neurons\n', size(inputs,1));
fprintf('Hidden Layer 1: %d neurons (%s)\n', hiddenSize, net.layers{1}.transferFcn);
fprintf('Output Layer: %d neurons (%s)\n', size(targets,1), net.layers{2}.transferFcn);
fprintf('Training Algorithm: %s\n', net.trainFcn);
fprintf('Performance Function: %s\n', net.performFcn);
fprintf('Max Epochs: %d\n', net.trainParam.epochs);

fprintf('\n==== Performance Benchmarks (n=%d runs) ====\n', nRepeats);
fprintf('Average Training Time: %.4f seconds (+/-%.4f)\n', mean(trainTimes), std(trainTimes));
fprintf('Average Memory Usage: %.4f MB (+/-%.4f)\n', mean(memUsages), std(memUsages));
fprintf('Average Throughput: %.2f samples/second (+/-%.2f)\n', mean(throughputs), std(throughputs));

save('D:\Assingments\03) Refferals Coursework (AIML)\02) Project\results\nn_architecture_benchmark.mat', ...
    'hiddenSize', 'trainTimes', 'memUsages', 'throughputs');
