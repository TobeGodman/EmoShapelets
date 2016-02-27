function [train_shape_struct, test_shape_struct] = generateShapelets(train_emoto_struct, test_emoto_struct)

    % extract shapelets from training set
    trainShapelets = extractShapelets(train_emoto_struct.signals, train_emoto_struct.labels);

    % apply shapelet transform
    fprintf('..transforming shapelets \n')
    train_shapeFeats = shapeletTransform(train_emoto_struct.signals, trainShapelets);
    test_shapeFeats = shapeletTransform(test_emoto_struct.signals, trainShapelets);

    % set outputs
    train_shape_struct = train_emoto_struct;
    train_shape_struct.shapelets = trainShapelets;
    train_shape_struct.shapeletsFeats = train_shapeFeats;

    test_shape_struct = test_emoto_struct;
    test_shape_struct.shapelets = trainShapelets;
    test_shape_struct.shapeletsFeats = test_shapeFeats;

end
