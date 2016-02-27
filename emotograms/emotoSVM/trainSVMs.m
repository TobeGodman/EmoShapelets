function SVMs = trainSVMs(speakers_in, uniqueLabels1)

% get number of speakers
numSpeakers = length(speakers_in);

% sanity check for labels (make sure we have 4)
uniqueLabels2 = unique(speakers_in(1).rawLabels);
assert(numel(uniqueLabels2)==4)
numel(numel(intersect(uniqueLabels2, uniqueLabels1))==4);

% set number of labels
numUniqueLabels = numel(uniqueLabels1);

% initialize SVMs
SVMs(numUniqueLabels,1).model = [];
SVMs(numUniqueLabels,1).label = [];
SVMs(numUniqueLabels,1).params = [];

% get all features, labels, and speaker number
totalInstances = length(cell2mat({speakers_in(:).rawInstanceSrc}'));
featDim = size(speakers_in(1).rawFeats,2);
allFeats = zeros(totalInstances, featDim);
allLabels = cell(totalInstances, 1);
allSpeakerNum = zeros(totalInstances, 1);
idx = 1;
for i=1:numSpeakers
    for j=1:length(speakers_in(i).rawInstanceSrc)
        allFeats(idx,:) = speakers_in(i).rawFeats(j,:);
        allLabels{idx,:} = speakers_in(i).rawLabels{j,:};
        allSpeakerNum(idx,:) = i;
        idx = idx + 1;
    end
end

% for each label
for i=1:numUniqueLabels

	% get current label
    currLabel = uniqueLabels1(i);

    fprintf('..label: %s (%d/%d)\n', currLabel{1}, i, numUniqueLabels);

    % transform labels into 1/-1
    allLabelsT = 1*strcmp(currLabel, allLabels);
    allLabelsT(allLabelsT~=1) = -1;

    % get hyper-parameters using leave-one-speaker-out (LOSO)
    fprintf('....tuning \n')
    hyperParams = tuneSVM_LOSO(allFeats, allLabelsT, allSpeakerNum);

    % train SVM using optimal hyper parameters on all data
    fprintf('....training \n')
    model = trainSVM(allFeats, allLabelsT, hyperParams, 1);

    % save output
    SVMs(i,1).model = model;
    SVMs(i,1).label = currLabel{1};
    SVMs(i,1).params = hyperParams;

end


end