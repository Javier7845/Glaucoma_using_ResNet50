% Allows the image pre-processing
clc;clear all;close all

% Select the specific database that contains the images to be pre-processed (Ask for new directory).
myFolder = uigetdir();

% Seleccionar el formato de imagen
a='*.jpg';
b='*.png';
c='*.jpeg';
d='*.bmp';
e='*.tiff';
list = {a,b,c,d,e};
[indx,tf] = listdlg('PromptString',{'Image format - Database.','Only one file can be selected.',''},'SelectionMode','single','ListString',list,'ListSize',[250,150]);

alfa=char(list(indx));
filePattern = fullfile(myFolder, alfa); % Change to whatever pattern you need.
theFiles = dir(filePattern);

% Seleccionar que hacer
% Escalamiento, Filtro rojo o Recortar areas negras
list = {'Luminosity correction',...
    'Contrast enhancement',...
    'Filter color',...
    'Normalizar',...
    'Resize (227x227 px)',...
    'Cropping black areas - Images'};

[ind,tf] = listdlg('PromptString',{'Select a function.','Only one option can be selected at a time.',''},'SelectionMode','single','ListString',list,'ListSize',[250,150]);



for k = 1 : length(theFiles)
    % Toma el nombre de la imagen
    baseFileName = theFiles(k).name;
    % Concatena para obtener todo el path de la imagen
    fullFileName = fullfile(theFiles(k).folder, baseFileName);
    fprintf(1, 'Now reading %s\n', fullFileName);

    % Luminosity correction
    if ind==1
        % Input
        imageArray= imread(fullFileName);
        %figure,imshow(imageArray),title('Input');
        [a,b]=size(imageArray);
        % A HSV
        HSV = rgb2hsv(imageArray);
        %subplot(2,2,2),imshow(HSV),title('HSV');
        HSVH=HSV(:,:,1);
        HSVS=HSV(:,:,2);
        HSVV=HSV(:,:,3);
        HSVd = double(HSVV);
        %subplot(2,2,3),imshow(HSVd),title('V');
        [m,n]=size(HSVd);
        gamma=0.4;
        out=abs((1*HSVd).^gamma);
        %subplot(2,2,4),imshow(out),title('Gamma');
        Z = imdivide(out,HSVd);
        %figure,imshow(Z),title('G/V');
        Fi=cat(3,HSVH,HSVS,Z);
        Z = immultiply(Fi,HSV);
        %figure,imshow(hsv2rgb(Z)),title('FxG');
        imwrite(hsv2rgb(Z),fullFileName);
    

    %Contrast enhancement
    elseif ind==2
        %Contrast enhancement
        lab= imread(fullFileName);
        i=rgb2gray(lab);
        h2=adapthisteq(i,'ClipLimit',0.009);
        %subplot(2,2,1),imshow(h2),title('Adapthisteq Image');
        %subplot(2,2,2),imhist(h2),title('Adapthisteq Histogram');
        imwrite(h2,fullFileName);

    
    % Add red filter color
    % Grayscale to RGB converter
    elseif ind==3
        %{
        imageArray= imread(fullFileName);
        delta = grs2rgb(imageArray);
        imwrite(delta,fullFileName);
        %}
        imageArray=imread(fullFileName);
        imageArray=imageArray(:,:,2);
        imwrite(imageArray,fullFileName);

    % Normalizar
    elseif ind==4
        imageArray= imread(fullFileName);
        normImage = im2double(imageArray);
        imwrite(normImage,fullFileName);

    % Resize the images
    elseif ind==5
        imageArray= imread(fullFileName);
        img= imresize(imageArray,[227 227]);
        imwrite(img,fullFileName);


    % Crop black border of images
    else
        imageCOLOR= imread(fullFileName);
        imageRGB = imageCOLOR;
        imageArray = rgb2gray(imageRGB);
        binaryImage = imbinarize(imageArray);
        [rows, columns] = find(binaryImage);
        topRow = min(rows);
        bottomRow = max(rows);
        leftColumn = min(columns);
        rightColumn = max(columns);
        croppedImage = imcrop(imageCOLOR,[leftColumn topRow (rightColumn-leftColumn) (bottomRow-topRow)]);
        imwrite(croppedImage,fullFileName);
    end
    drawnow; % Force display to update immediately.
end