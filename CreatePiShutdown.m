function CreatePiShutdown(serPort)
%
%   The object 'ports' must first be initialized with the 
%   CreateBeagleInit command (available as part of the Matlab Toolbox for 
%   the iRobot Create).
%
% By: Liran 1/2019

 data_to_send = ('stop');
 fwrite(serPort, data_to_send);
 pause(2);
 
try
    fclose(serPort);
    delete(serPort);
    pause(1);
catch
    disp('WARNING:  Function did not terminate correctly.  Output may be unreliable.')
end
end