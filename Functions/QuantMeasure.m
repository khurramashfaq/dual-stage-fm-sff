function [RMSE, CORR] = QuantMeasure(groundtruth , calculated)
CORR = corr2(groundtruth(:),calculated(:));
RMSE = sqrt( mean2( (double(groundtruth)-double(calculated)).^2 ) );

end

