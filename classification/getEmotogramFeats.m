function [speakers_out] = getEmotogramFeats(speakers_in)

    numSpeakers = length(speakers_in);    
    speakers_out = speakers_in;

    for i=1:numSpeakers
        currSpeaker = speakers_in(i);
        EmotoFeats = zeros(length(currSpeaker.EmotoSequences), 6*4+1);

        for j=1:size(EmotoFeats,1)
            EmotoFeats(j,:) = extractFeats(currSpeaker.EmotoSequences{j});
        end
        speakers_out(i).EmotoStatsData.Xte =  EmotoFeats;
        speakers_out(i).EmotoStatsData.Yte =  speakers_out(i).EmotoLabelsT;
        temp(i).Xte = EmotoFeats;
        temp(i).Src = ones(size(EmotoFeats,1),1)*i;
    end

    for i=1:numSpeakers
        trSpeakers = speakers_out([1:numSpeakers]~=i);
        tempTr = temp([1:numSpeakers]~=i);        
        speakers_out(i).EmotoStatsData.Xtr = vertcat(tempTr(:).Xte);
        speakers_out(i).EmotoStatsData.Ytr = vertcat(trSpeakers(:).EmotoLabelsT);
        speakers_out(i).EmotoStatsData.Srctr = vertcat(tempTr(:).Src);
    end

end

function [feats_out] = extractFeats(signal_in)

    meanFeats = mean(signal_in,2);
    stdFeats = std(signal_in, [], 2);
    [maxFeats, maxLocFeats] = max(signal_in, [], 2);
    [minFeats, minLocFeats] = min(signal_in, [], 2);

    feats_out = [meanFeats', stdFeats', maxFeats', maxLocFeats', ...
                 minFeats', minLocFeats', size(signal_in,2)];
end
