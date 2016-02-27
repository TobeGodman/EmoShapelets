function shapelets_out = removeSelfSimilar(shapelets_in)

numShapeletes = length(shapelets_in);
toDelete = false(1, numShapeletes);

% start from end
for i=numShapeletes:-1:2
    currStartIdx = shapelets_in(i).startIdx;
    currEndIdx = shapelets_in(i).endIdx;
    for j=i-1:-1:1
        checkStartIdx = shapelets_in(j).startIdx;
        checkEndIdx = shapelets_in(j).endIdx;

        if ((currStartIdx <= checkStartIdx) && (checkStartIdx <= currEndIdx)) || ...
           ((currStartIdx <= checkEndIdx) && (checkEndIdx <= currEndIdx)) || ...
           ((checkStartIdx <= currStartIdx) && (currEndIdx <= checkEndIdx))
            toDelete(i) = true;
            break;
       end        

    end
end

shapelets_out = shapelets_in;
shapelets_out(toDelete) = [];

end