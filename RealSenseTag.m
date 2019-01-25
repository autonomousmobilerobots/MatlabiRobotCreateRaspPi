 function tags = RealSenseTag(serPort);
% tags = RealSenseTag(serPort) Finds AprilTags in the image from the
% camera. Returns the id of the AprilTag, position in the frame of the
% camera, and rotation about its center.
%
%   Camera coordinate frame is defined as:
%       x - axis points to right
%       y - axis points down
%       z - axis points out of camera (depth)
%
%   Each row of the array is [id z x rot]
%   
%   id = The id number of the AprilTag
%   z = The z-distance of the AprilTag in the camera coordinate frame
%   x = The x-distance of the AprilTag in the camera coordinate frame
%   rot = The orientation of the tag, in radians
%
%   If no tags are detected, returns an empty array
    
%Flush Buffer    
N = serPort.BytesAvailable();
while(N~=0) 
fread(serPort,N);
N = serPort.BytesAvailable();
end

warning off
global td
data_to_send = ('tag');
fwrite(serPort, data_to_send);

disp('waiting for response');
while serPort.BytesAvailable==0
    pause(0.1);
end
resp = fread(serPort, serPort.BytesAvailable); % Get response and convert to char array
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
% disp('got data!');
% fprintf('response was: %s\n',resp); % Print response to command window
pause(td)
return

end