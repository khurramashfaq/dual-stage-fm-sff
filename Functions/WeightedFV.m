function wfv = WeightedFV(fv)
    [a ,b, c, d ~] = size(fv);

    %% Kurtosis Based Selection
    Kur_Dir = zeros(a, b, d); F_Curve = zeros(c,1); 
    for i=1:1:d
        kur_values = zeros(a,b);

        for x=1:1:a
            for y =1:1:b

               

                F_Curve(:,1) = fv(x,y,:,i);

                kur_pix = kurtosis(F_Curve);
                kur_values(x,y) = kur_pix;

                if isnan(kur_pix)
                    kur_values(x,y) = 0;
                end
            end
        end
                         
        Kur_Dir(:,:,i) = kur_values;
    end

    Cons_Final= sum(Kur_Dir,[1 2]);
    Cons_Final = reshape(Cons_Final,[d,1]);

    Kur_all_rescaled = rescale(Cons_Final,0,1);


    %% Consensus Based Selection
    
    % Finding depth 
    F_dir_Depth_all = zeros(a,b,d);
    F_dir_Depth_all(:,:,:) = DepthMap(fv(:,:,:,:));   

    %Finding Mode depth from directional vectors
    Mode_Depth_all = zeros(a,b); Pix_Dep_all = zeros(d,1);
    for x=1:1:a
        for y=1:1:b
            Pix_Dep_all(:,1) = F_dir_Depth_all(x,y,:);
            Mode_Depth_all(x,y) = mode(Pix_Dep_all);

        end
    end

    Cons_all = zeros(a,b,d) ;
    for k = 1:d 
    layerResult = (F_dir_Depth_all(:, :, k) == Mode_Depth_all(:,:)) | (F_dir_Depth_all(:, :, k) == Mode_Depth_all + 1) | (F_dir_Depth_all(:, :, k) == Mode_Depth_all - 1) ;
    Cons_all(:,:,k) = layerResult;
    end

    Cons_Final= sum(Cons_all,[1 2]);
    Cons_Final = reshape(Cons_Final,[d,1]);

    Cons_Final_Rescaled = rescale(Cons_Final,0,1);


    %% Adding Kurtosis and Consensus
    Weight_Total = Kur_all_rescaled + Cons_Final_Rescaled;

    WeightedFVs = zeros(a,b,c,d) ;
    for i=1:1:d
        WeightedFVs(:,:,:,i) = fv(:,:,:,i).* Weight_Total(i,1);
    end


    %% Focus Volume Final (Single)

    wfv = zeros(a,b,c);
    for i=1:1:d
        wfv(:,:,:) =  wfv(:,:,:) +  WeightedFVs(:,:,:,i)  ;  
    end








end
