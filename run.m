clear;
warning('off');
clc;
times=10;
fold=5;
dataset_name = 'yeast';
cd('datasets');
    eval(['load ', dataset_name]);
cd('..');
%≤Œ ˝…Ë÷√
 opt_params.lam1 = 0.002;
 opt_params.lam2 = 0.002;
 opt_params.lam3 =64;
 opt_params.lam4 = 0.1;
 opt_params.maxIter = 200;
 opt_params.minimumLossMargin = 0.0001;
 features = zscore(features);
 num_instance = size(features, 1);
 num_class=size(labels,2);
 lastcol = ones(num_instance,1);
 features = [features, lastcol];
 num_class = size(labels,2);
 experiment_result = zeros(times, 5);
for itrator = 1:times
    indices = crossvalind('Kfold', num_instance, 5);
    temp_result = zeros(fold, 5);
    for rep = 1: fold
         fprintf('========================== %d %d ============================\n', itrator, rep);
         testIdx = find(indices == rep);
         trainIdx = setdiff(find(indices),testIdx);
         test_data = features(testIdx,:);
         train_data = features(trainIdx,:);
         test_targets = labels(testIdx,:);
         train_targets = labels(trainIdx,:);
         pre_mod_label=[];
        
         %Train model
         for k = 1: num_class
             test_targets_k = test_targets(:,k);
             train_targets_k = train_targets(:,k);
             [W_k]  =ML_LSS (train_data, train_targets_k, opt_params);
             W(:,k)=W_k;
         end
         
         %Prediction
         [pre_labels, pre_dis, res_once] = ML_LSS_predict(W, test_data, test_targets);
        
         temp_result(rep, :) = res_once;
    end
    experiment_result(itrator, :) = mean(temp_result,1);
end
meanres = mean(experiment_result, 1)
stdres = std(experiment_result, 1)



