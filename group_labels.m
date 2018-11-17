function labels = group_labels(labs, groups)
% changes numbers labels to labels of the group that the number belongs to
% groups - partition of numbers into smaller groups. One row contain number belonging to one group. 
% If groups are non-equinumerous, last columns are filled with -1. 

  labels = zeros(size(labs));
  for i = 1:rows(groups)
    for j = 1:columns(groups)
      labels(labs == groups(i,j)) = i;
    end
  end

end