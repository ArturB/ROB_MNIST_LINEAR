function dist = pdistG(cfmx)
% transforms a confusion matrix into distancesa vector, acceptable by linkage function

  cfmx(:,columns(cfmx)) = [];
  cfmx += cfmx';
  dist = zeros(0);
  for i = 1:columns(cfmx)
    dist = [dist; cfmx(i+1:end,i)];
  end
  dist = 10 + max(dist) .- dist;
  
end