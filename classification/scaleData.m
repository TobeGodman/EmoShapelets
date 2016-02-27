function X_out = scaleData(X_in)

% now scale the full matrix
X_out = ones(size(X_in))*NaN;
dim = size(X_in,2);

for i=1:dim
    xmin = nanmin(X_in(:,i));
    xmax = nanmax(X_in(:,i));
    X_out(:,i) = (X_in(:,i)-xmin)./(xmax-xmin);
    % assert(xmin~=xmax)
    if xmin==xmax
        X_out(:,i) = 0;
    end
end
