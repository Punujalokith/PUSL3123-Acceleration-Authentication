function [X, y] = build_domain_impostor_set(allData, targetUser, nImpostorPerOther, fieldName)

arguments (Input)
    allData (1,1) struct
    targetUser (1,1) double {mustBeInRange(targetUser,1,10)}
    nImpostorPerOther (1,1) double {mustBePositive}
    fieldName (1,:) char
end

arguments (Output)
    X double
    y double
end

uidTarget = sprintf('U%02d', targetUser);
genuineX = allData.(uidTarget).(fieldName);
genuineY = ones(size(genuineX,1), 1);

impostorX = [];
for u = 1:10
    if u == targetUser
        continue
    end
    uid = sprintf('U%02d', u);
    otherX = allData.(uid).(fieldName);
    pickRows = randperm(size(otherX,1), nImpostorPerOther);
    impostorX = [impostorX; otherX(pickRows, :)];
end

impostorY = zeros(size(impostorX,1), 1);

X = [genuineX; impostorX];
y = [genuineY; impostorY];

end
