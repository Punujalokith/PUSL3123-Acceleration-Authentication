users = 1:10;
allData = struct();
for u = users
    uid = sprintf('U%02d', u);
    S = load(sprintf('%s_Acc_TimeD_FreqD_FDay.mat', uid));
    allData.(uid).TimeD_FreqD_FDay = S.Acc_TDFD_Feat_Vec;
    S = load(sprintf('%s_Acc_TimeD_FreqD_MDay.mat', uid));
    allData.(uid).TimeD_FreqD_MDay = S.Acc_TDFD_Feat_Vec;
    S = load(sprintf('%s_Acc_TimeD_FDay.mat', uid));
    allData.(uid).TimeD_FDay = S.Acc_TD_Feat_Vec;
    S = load(sprintf('%s_Acc_TimeD_MDay.mat', uid));
    allData.(uid).TimeD_MDay = S.Acc_TD_Feat_Vec;
    S = load(sprintf('%s_Acc_FreqD_FDay.mat', uid));
    allData.(uid).FreqD_FDay = S.Acc_FD_Feat_Vec;
    S = load(sprintf('%s_Acc_FreqD_MDay.mat', uid));
    allData.(uid).FreqD_MDay = S.Acc_FD_Feat_Vec;
end
