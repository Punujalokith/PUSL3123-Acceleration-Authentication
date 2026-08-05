function [X, y] = make_genuine_impostor_set(data, targetUser, nImpostorPerOther)

arguments (Input)
    data (1,1) struct
    targetUser (1,1) double {mustBeInRange(targetUser,1,10)}
    nImpostorPerOther (1,1) double {mustBePositive}
end

arguments (Output)
    X double
    y double
end

uidTarget = sprintf('U%02d', targetUser);
genuineX = data.(uidTarget).TimeD_FreqD_FDay;
genuineY = ones(size(genuineX,1), 1);

impostorX = [];
for u = 1:10
    if u == targetUser
        continue
    end
    uid = sprintf('U%02d', u);
    otherX = data.(uid).TimeD_FreqD_FDay;
    pickRows = randperm(size(otherX,1), nImpostorPerOther);
    impostorX = [impostorX; otherX(pickRows, :)];
end

impostorY = zeros(size(impostorX,1), 1);

X = [genuineX; impostorX];
y = [genuineY; impostorY];

end