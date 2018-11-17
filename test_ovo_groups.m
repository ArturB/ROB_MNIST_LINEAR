function [cfmxRef cfmxG cfmxPre] = test_ovo_groups(tvec, tlab, tstv, tstl, groups, comp_count = 40)
% Compare two methods of classyfying numbers: with- or without pre-groupping.
% tvec - training images
% tlab - training images labels
% tstv - test images
% tstl - test images labels
% groups - partition of numbers into smaller groups. One row contain number belonging to one group. 
% If groups are non-equinumerous, last columns are filled with -1. 
% comp_count - number of PCA components to compute

  printf("Calculating %i first PCA components...\n", comp_count); fflush(stdout);
  
  % calculating PCA-transformed data...
  [mu trmx] = prepTransform(tvec, comp_count);
  tvec = pcaTransform(tvec, mu, trmx);
  tstv = pcaTransform(tstv, mu, trmx);
  tlabg = group_labels(tlab, groups);
  tstlg = group_labels(tstl, groups);
  
  printf("PCA components calculated!\nTraining perceptron...\n"); fflush(stdout);
  
  % dividing training data into groups
  tg = {}; 
  tl = {}; 
  tstvgs = {}; 
  tstlgs = {}; 
  
  for i = 1:rows(groups)
    tg{i} = zeros(0);
    tl{i} = zeros(0);
    tstvgs{i} = zeros(0);
    tstlgs{i} = zeros(0);
    for j = 1:columns(groups)
      if groups(i,j) != -1
        tg{i} = [tg{i}; tvec(tlab == groups(i,j),:)];
        tl{i} = [tl{i}; tlab(tlab == groups(i,j),:)];
        tstvgs{i} = [tstvgs{i}; tstv(tstl == groups(i,j),:)];
        tstlgs{i} = [tstlgs{i}; j * ones(size(tstl(tstl == groups(i,j),:)))];
        
      end
    end
  end  
  
  % training referential perceptron with no pre-groupping
  ovor = trainOVOensamble(tvec, tlab, @perceptron);
  
  % training OVO perceptrons for each group and merge with referential perceptron to ensure consistency
  ovog = {};
  for i = 1:rows(groups)
    ovog{i} = trainOVOensamble(tg{i}, tl{i}, @perceptron);
    for j = 1:rows(ovog{i})
      ovor( ovor(:,1) == ovog{i}(j,1) & ovor(:,2) == ovog{i}(j,2), : ) = ovog{i}(j,:);
    end
  end
  
  % training perceptron that divides numbers into groups
  ovof = trainOVOensamble(tvec, tlabg, @perceptron);
  
  printf("Perceptron trained!\nCalculating confusion matrix...\n"); fflush(stdout);
  
  % cfmx for referential perceptron
  printf("\n\nConfusion matrix for referential perceptron:\n"); fflush(stdout);
  clabRef = unamvoting(tstv, ovor);
  cfmxRef = confMx(tstl, clabRef)
  compErrors(cfmxRef)
  
  % show confusion matrix for dividing numbes into groups problem itself...
  printf("Confusion matrix for dividing numbers into groups:\n"); fflush(stdout);
  glab = unamvoting(tstv, ovof);
  cfmxG = confMx(tstlg, glab)
  compErrors(cfmxG)
  
  % show confusion matrices for small perceptrons
  printf("Confusion matrices for small perceptrons:\n"); fflush(stdout);
  for i = 1:rows(groups)
    slab = unamvoting(tstvgs{i}, ovog{i});
    cfmxS = confMx(tstlgs{i}, slab)
    compErrors(cfmxS)
  end
  
  % show confusion matrix for pre-groupping numbers classifier
  printf("Confusion matrix for pre-grouping classifier:\n"); fflush(stdout);
  clabPre = zeros(size(clabRef));
  for i = 1:rows(clabPre)
    clabPre(i) = groups(glab(i), unamvoting(tstv(i,:), ovog{glab(i)} ) );
  end
  cfmxPre = confMx(tstl, clabPre)
  compErrors(cfmxPre)
    
  printf("All done!\n");

end
