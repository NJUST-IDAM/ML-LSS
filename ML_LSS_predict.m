function [pre_label, modProb,res_once] = ML_LSS_predict(weights, test_feature, test_target)
    modProb = test_feature * weights;
    pre_label = modProb;
    pre_label(pre_label>0) = 1;
    pre_label(pre_label<=0) = -1;
    cd('evaluation');
        HammingLoss = Hamming_loss(pre_label', test_target');
        RankingLoss = Ranking_loss(modProb', test_target');
        OneError = One_error(modProb', test_target');
        Coverage = coverage(modProb', test_target');
        Average_Precision = Average_precision(modProb', test_target');
    cd('..');
    res_once = [HammingLoss, RankingLoss, OneError, Coverage, Average_Precision];
end