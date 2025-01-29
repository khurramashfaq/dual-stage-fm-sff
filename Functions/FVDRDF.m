function fv = FVDRDF(imgs,in,gap,out)


[z,~]=size(imgs);
[m n ~]=size(imgs{1});
fv=zeros(m,n,z,6);


%% RDF of given in , gap and out
rdf = -(ceil(fspecial('disk', in + gap + out - 1)) - ceil(padarray(padarray(fspecial('disk', in + gap - 1), out, 0)', out, 0)));
rdf(rdf > 0) = 0;
rdf(floor(in / 2) + gap + out + 1, floor(in / 2) + gap + out + 1) = -sum(rdf(:));

%% Finding the mid row and mid column
dimensions=size(rdf);
midsize = round(dimensions/2);

midrow = midsize(1,1);
midcolumn = midsize(1,2);


%% h1 and h2

h1 = zeros(dimensions);
h1(:,midcolumn ) = rdf(:,midcolumn);
h1(midrow,midcolumn) = 2*out; 

h2 = h1';


%% h3 and h4

h3 =zeros(dimensions);
h3(1:midrow-1,midcolumn+1) = rdf(1:midrow-1,midcolumn+1);
h3(midrow+1:end,midcolumn-1) =  rdf(midrow+1:end,midcolumn-1);
h3(midrow,midcolumn) = 2*out;

h4 = h3' ;


%% h5 and h6

h5 = rot90(h4,1);
h6 = rot90(h3,1);


%% Evaluating 6 FVs

I1 = zeros(m,n,z); I2=I1 ; I3 = I1 ; I4 =I1 ; I5 = I1 ; I6 = I1;

for j=1:6
    for i=1:z
        img = imgs{i};
        filterName = sprintf('h%d', j);
        varName = sprintf('I%d(:,:,i)', j);

        X = imfilter(img, eval(filterName) ,'conv','replicate', 'same');
        eval([varName ' = sum(abs(X),3);']);
    end    
end



fv(:,:,:,1) = I1;  fv(:,:,:,2) = I2;  fv(:,:,:,3) = I3;  fv(:,:,:,4) = I4; fv(:,:,:,5) = I5;  fv(:,:,:,6) = I6; 



end