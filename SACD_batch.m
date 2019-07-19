clc;clear;close all;warning off;
%SACD reconstruction
%-------------------------------------------------------------------------------------
%  
%
% Code modified from 2018 Weisong Zhao et al, "Temporal resolution enhancement in
%   super-resolution imaging with auto-correlation two-step deconvolution
%   ," Opt. Express... 
%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with this program.  If not, see <http://www.gnu.org/licenses/>.
%-------------------------------------------------------------------------------------
%load HDT.mat


fileFolder = fullfile(uigetdir(matlabroot,'MATLAB Root Folder'));

dirOutput = dir(fullfile(fileFolder,'*.tif'));
fileNames = {dirOutput.name}'

endName='_PostSACD.tif';

I = imread(fileNames{1});
imshow(I);
text(size(I,2),size(I,1)+15, ...
    'Image files courtesy of Alan Partin', ...
    'FontSize',7,'HorizontalAlignment','right');
text(size(I,2),size(I,1)+25, ....
    'Johns Hopkins University', ...
    'FontSize',7,'HorizontalAlignment','right');

for i = 1:length(fileNames)
    
FileTif=fileNames{i};
InfoImage=imfinfo(FileTif);
mImage=InfoImage(1).Width;
nImage=InfoImage(1).Height;
NumberImages=length(InfoImage);
HDT=zeros(nImage,mImage,NumberImages,'uint16');
 
TifLink = Tiff(FileTif, 'r');
for i=1:NumberImages
   TifLink.setDirectory(i);
   HDT(:,:,i)=TifLink.read();
end
TifLink.close();

%Inputs:
%data      diffraction limit image sequence
%NA        NA {example:1.49}
%pixel     pixel size {example:65*10^-9}
%lamda    wavelength {example:532*10^-9}
%iter      Maximum deconvolution iterations {example:20}
%mag      magnification times  {example:8}
%squre    PSF^2 {example:2}
%order     Auto-correlation cumulant order  {example:2}


image=SACD_recon(HDT(:,:,1:40),1.15,247*10^-9,647*10^-9,1,5,2,3);
image2 = imadjust(image)
imshow(image2,'Colormap',hot,'border','tight','initialmagnification','fit')
ExportName = fullfile(fileFolder,[FileTif,endName]);

imwrite(image2, ExportName)

end
