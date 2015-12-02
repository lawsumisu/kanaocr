%% Helper function for extracting bounds from a column vector.
function [startPoints, endPoints] = findBounds(column)
%Iterate through column, saving start and end points.
startPoints = [];
endPoints = [];
startFlag = 0;
for i = 1:length(column)
    if startFlag && column(i) ==0
        %Encountered a 0, so add previous index as an end point.
        endPoints = [endPoints i-1];
        startFlag = 0;
    elseif startFlag && i == length(column)
        %Reached end of line, so add this index as an end point.
        endPoints = [endPoints i];
    elseif ~startFlag && column(i) == 1
        %Encountered a 1, so add this index as a start point.
        startFlag = 1;
        startPoints = [startPoints i];   
    end
end