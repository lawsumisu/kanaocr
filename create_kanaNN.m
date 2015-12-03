close all;
%% Character Recognition on Japanese Kana
% 

%% Defining the Problem
%
setdemorandstream(pi);

[X,T] = kanaPD;
Xdim = size(X);
numCharacters = Xdim(2);
vectorLength = Xdim(1);

%% Training the Neural Network (with Noise)
% We would like the network to recognize not only the normal formed kana,
% but also kana of differing handwriting.  So we will try training
% a second network on noisy data to see if that better generalizes the
% network.
%
% Here 30 noisy copies of each letter Xn are created.  Values are limited
% by *min* and *max* to fall between 0 and 1.  The corresponding targets
% Tn are also defined.

numNoise = 30;
Xn = min(max(repmat(X,1,numNoise)+randn(vectorLength,numCharacters*numNoise)*0.2,0),1);
Tn = repmat(T,1,numNoise);
%%
% Here the neural network is created, trained, and saved to a file..

net = feedforwardnet(25);
% view(net)
% net1.divideFcn = '';
net = train(net,Xn,Tn,nnMATLAB);

save kanaNet net
