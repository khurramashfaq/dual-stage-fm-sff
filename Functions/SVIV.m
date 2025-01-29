%% Proposed : Scalar Valued Image volume
function svimgs = SVIV(imgs)
[z ~]=size(imgs);
[m n ~]=size(imgs{1});
svimgs=cell(z,1);

for i = 1:z
    img = imgs{i};
    svimgs{i}=SVimg(img);
end
end

%%  Scalar Valued image from vector valued image
function F = SVimg(img)

[h,w,c]=size(img);
P = padarray(img, [1 1], 'replicate');
N1 = P(2:end-1, 3:end, :);
N2 = P(2:end-1, 1:end-2, :);
N3 = P(1:end-2, 2:end-1,:);
N4 = P(3:end, 2:end-1,:);
N5 = P(1:end-2, 3:end,:);
N6 = P(1:end-2, 1:end-2,:);
N7 = P(3:end, 3:end,:);
N8 = P(3:end, 1:end-2,:);

D1=img-N1;
D2=img-N2;
D3=img-N3;
D4=img-N4;
D5=img-N5;
D6=img-N6;
D7=img-N7;
D8=img-N8;
D9=img-img;

F11=D1+D2+D3+D4+D5+D6+D7+D8+D9; 
F1=dot(F11,F11,3); 

M1=dot(D1,D1,3); 
M2=dot(D2,D2,3);
M3=dot(D3,D3,3);
M4=dot(D4,D4,3);
M5=dot(D5,D5,3);
M6=dot(D6,D6,3);
M7=dot(D7,D7,3);
M8=dot(D8,D8,3);
M9=dot(D9,D9,3);  

F21=[M1(:),M2(:),M3(:),M4(:),M5(:),M6(:),M7(:),M8(:), M9(:)];
F22=var(F21,0,2);     
F2=reshape(F22,h,w);
F=F1.*F2;    



end