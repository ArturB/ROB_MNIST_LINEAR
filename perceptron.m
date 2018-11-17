function [sepplane fp fn] = perceptron(pclass, nclass)
% Computes separating plane (linear classifier) using
% perceptron method.
% pclass - 'positive' class (one row contains one sample)
% nclass - 'negative' class (one row contains one sample)
% Output:
% sepplane - row vector of separating plane coefficients
% fp - false positive count (i.e. number of misclassified samples of pclass)
% fn - false negative count (i.e. number of misclassified samples of nclass)

  sepplane = rand(1, columns(pclass) + 1) - 0.5;
  tset = [ ones(rows(pclass), 1) pclass; -ones(rows(nclass), 1) -nclass];
  nPos = rows(pclass); % number of positive samples
  nNeg = rows(nclass); % number of negative samples
  i = 0; rowsall = rows(tset);
  do 
    i++;
    if i == 1 
      prevErr = 0;
    else
      prevErr = sum(errs) / rowsall;
    end
	  cls = sum(tset .* sepplane, 2);
	  errs = cls < 0;
    sepplane = sepplane + sum(tset(errs,:));
  until (abs(prevErr - sum(errs)/rowsall) < 0.0001 || i > 300)

  fp = sum(errs(1:rows(pclass)));
  fn = sum(errs(rows(pclass)+1:end));
  
