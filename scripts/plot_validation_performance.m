load_dataset;

[X, y] = make_genuine_impostor_set(data, 1, 4);
inputs = X';
targets = zeros(2, numel(y));
targets(1, y==1) = 1;
targets(2, y==0) = 1;

net = patternnet(10);
net.trainParam.showWindow = false;
[net, tr] = train(net, inputs, targets);

figure;
plotperform(tr);

saveas(gcf, 'D:\Assingments\03) Refferals Coursework (AIML)\02) Project\report\graphs\validation_performance_01.png');
fprintf('Saved figure: validation_performance_01.png\n');
fprintf('Best validation performance: %.4g at epoch %d\n', tr.best_vperf, tr.best_epoch);
