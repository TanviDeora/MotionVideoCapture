%%

% create filename and path for saving video
string=datestr(now,'yyyy_mm_dd'); 
mkdir('C:\Users\Daniellab\Documents\TanviStuff\Test Video',string)
fpath = ['C:\Users\Daniellab\Documents\TanviStuff\Test Video\' ,string, '\'];

prompt = 'Input the filename?  ';
fname = input(prompt,'s');

% Create the video object.
vid1 = videoinput('gige', 3, 'Mono8');
cam1 = getselectedsource(vid1);

% create a variable for motion detection
BaseImage= getsnapshot(vid1);
imshow(BaseImage)
pause
close all

% set the camera parameters
cam1.ExposureTimeAbs = 499.999987368938;
cam1.AcquisitionFrameRateEnable = 'True';
cam1.AcquisitionFrameRateAbs = 100;

trial=1; % start with trial number 1 and keep adding to filename
vid1.LoggingMode = 'memory';

   
% Start capturing images for motion analysis.
delay = 0.2; % how fast to do want to detect motion (currently set to 50fps or 0.2 sec)? 
preview(vid1);

n=1; 
test = 1;
while 1
    currFrame = getsnapshot(vid1);
    motion = DetectMotion(BaseImage,currFrame);
    disp('MotionDetection started')
    diskLogger = VideoWriter([fpath fname '_trial', num2str(trial), '.avi'], 'Grayscale AVI');
    if motion == 1
        tic
        vid1.FramesPerTrigger = 1;
        vid1.TriggerRepeat = Inf;
        start(vid1)
        disp('MotionDetected')
        % continue detecting motion
        while test
            pause(delay)
            currFrame = getsnapshot(vid1);
            motion = DetectMotion(BaseImage,currFrame);
            if motion == 0
                stop(vid1)
                disp('MotionStopped')
                test = 0;
                trial=n+1; % add trialnumber to name of video
                %write to disk
                open(diskLogger);
                data = getdata(vid1, vid1.FramesAvailable);
                numFrames = size(data, 4);
                for ii = 1:numFrames
                    writeVideo(diskLogger, data(:,:,:,ii));
                end
                close(diskLogger);
                toc
            end
        end
        test = 1;
     end
    pause(delay)
end

% pause
% stop(vid1)
% stoppreview(vid1)
