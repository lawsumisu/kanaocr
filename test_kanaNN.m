%% Testing Both Neural Networks
[X,T] = kanaPD;
numNoise = 30;
Xdim = size(X);
numCharacters = Xdim(2);
vectorLength = Xdim(1);

noiseLevels = 0:.05:1;
numLevels = length(noiseLevels);
percError1 = zeros(1,numLevels);
Tn = repmat(T,1,numNoise);
for i = 1:numLevels
  Xtest = min(max(repmat(X,1,numNoise)+randn(vectorLength,numCharacters*numNoise)*noiseLevels(i),0),1);
  Y1 = net(Xtest);
  percError1(i) = sum(sum(abs(Tn-compet(Y1))))/(numCharacters*numNoise*2);
end

figure
plot(noiseLevels,percError1*100);
title('Percentage of Recognition Errors');
xlabel('Noise Level');
ylabel('Errors');
legend('Network 1','Location','NorthWest')