% Sample use of PointCloud2Image(...)
% 
% The following variables are contained in the provided data file:
%       BackgroundPointCloudRGB,ForegroundPointCloudRGB,K,crop_region,filter_size
% None of these variables needs to be modified


clc
clear all
% load variables: BackgroundPointCloudRGB,ForegroundPointCloudRGB,K,crop_region,filter_size)
load data.mat

data3DC = {BackgroundPointCloudRGB,ForegroundPointCloudRGB};
R       = eye(3);
% move    = [0 0 -0.25]';
move = [0 0 -0.3/10]';

for step=0:80
    tic
    fname       = sprintf('SampleOutput%03d.jpg',step);
    display(sprintf('\nGenerating %s',fname));
    t           = step * move;

%{
    Setup: Start the sequence using the camera’s original internal calibration matrix K (provided in the
data.mat file) and position the camera in such a way that the foreground object occupies in the
initial image a bounding box of approx 400 by 640 pixels (width and height) respectively.
Figure 1. The Dolly Zoom Effect
3
(Per reference, positioning the camera at the origin renders the foreground object within a
bounding box of size 250 by 400 pixels)
%}
    % Dolly zoom part
    fy          = (640 + 0) / (400 + 0) * (3800 + (step * move(3)*1000));
    K(1,1)      = fy;
    
    fx          = (400 + 0) / (250 + 0) * (3800 + (step * move(3)*1000));
    K(2,2)      = fx;
    %
    
    M           = K*[R t];
    im          = PointCloud2Image(M,data3DC,crop_region,filter_size);
    imwrite(im,fname);
    toc    
end
