function kshapelets_out = mergeShapelets(kshapelets_in, shapelets)

numKshapelets = length(kshapelets_in);
numShapelets = length(shapelets);
kshapelets_out = kshapelets_in;

shapeIdx = 1;
kshapeIdx = 1;
for i=1:numKshapelets

    if shapeIdx>numShapelets
        kshapelets_out(i) = kshapelets_in(kshapeIdx);
        kshapeIdx = kshapeIdx + 1;        
    elseif shapelets(shapeIdx).quality > kshapelets_in(kshapeIdx).quality
        kshapelets_out(i) = shapelets(shapeIdx);
        shapeIdx = shapeIdx + 1;
    else
        kshapelets_out(i) = kshapelets_in(kshapeIdx);
        kshapeIdx = kshapeIdx + 1;
    end
end

end