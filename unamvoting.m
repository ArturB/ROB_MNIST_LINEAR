function clab = unamvoting(tset, clsmx)
% Simple unanimity voting function 
% 	tset - matrix containing test data; one row represents one sample
% 	clsmx - voting committee matrix
% Output:
%	clab - classification result 

	% class processing
	labels = unique(clsmx(:, [1 2]));
	maxvotes = rows(labels) - 1; % unanimity voting in one vs. one scheme
	%reject = max(labels) + 1;
	
	% cast votes of classifiers
	votes = voting(tset, clsmx);
	
	[mv clab] = max(votes, [], 2);
  clabs = find(votes == mv);
  if columns(clabs) > 1
    clabs = clabs(randperm(columns(clabs)));
    clab = clabs(1);
  end
	%clab(mv ~= maxvotes) = reject;
