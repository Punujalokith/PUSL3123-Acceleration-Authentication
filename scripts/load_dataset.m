users = 1:10;
data = struct();
for u = users
    uid = sprintf('U%02d', u);
    S1 = load(sprintf('%s_Acc_TimeD_FreqD_FDay.mat', uid));
    S2 = load(sprintf('%s_Acc_TimeD_FreqD_MDay.mat', uid));
    data.(uid).TimeD_FreqD_FDay = S1.Acc_TDFD_Feat_Vec;
    data.(uid).TimeD_FreqD_MDay = S2.Acc_TDFD_Feat_Vec;
end