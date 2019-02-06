 function tags = RealSenseTag(serPort)
%RealSenseTag(serPort) returns a array of tags
%   Each row of the array is [id z x yaw]
%   
%   id = The id of the tag
%   z = The z-distance of the tag from the 
%   x = The horizontal distance of the center of the tag from the center of
%   the camera
%   yaw = The orientation of the tag, in radians
%   If no tag detected, return empty array
    
fopen(serPort);

warning off
global td


%disp('waiting for response');
while serPort.BytesAvailable==0
    %pause(0.1);
end

resp = fread(serPort, serPort.BytesAvailable); % Get response and convert to char array

fclose(serPort);

if resp == 99
    disp('No camera connected, cannot call this function')
else
	to_str = char(resp.');
	if strcmp(to_str,'no tags detected')
		tags = [];
		return
	end

	dataArr = strsplit(to_str, ' ');
	num_tags = (size(dataArr)-1)/5;
	num_tags = num_tags(2);
	tags = [];
	for i=1:num_tags
		loopCounter = (i-1)*5+1;
		id = str2double(dataArr(loopCounter+1));
		x = str2double(dataArr(loopCounter+2));
		y = str2double(dataArr(loopCounter+3));
		yaw = str2double(dataArr(loopCounter+4));
		temp = [id, x, y, yaw];
		tags = [tags;temp];
	end    
end	

pause(td)

return

end