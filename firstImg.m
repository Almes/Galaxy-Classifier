%matlab function to get the picture from the python program
function firstImg(imgPth)
  img = imread(imgPth);
  
  imgGray = rgb2gray(img);
  imgBinary = imbinarize(imgGray);

  %defaulting the detection rate to the spiral galaxy
  detectionRate = CompareSpiral(imgBinary);
  tempRate = CompareLenticur(imgBinary);
  galaxyName = "Spiral Galaxy";

  %If the temporary rate is lower than the detection rate we switch them
  %immse is the lower the number, the more it matches
  if tempRate < detectionRate
      detectionRate = tempRate;
      galaxyName = "Lenticur Galaxy";
  end
  tempRate = CompareElliptical(imgBinary);
  if tempRate < detectionRate
      detectionRate = tempRate;
      galaxyName = "Elliptical Galaxy";
  end
  tempRate = CompareBlazar(imgBinary);
  if tempRate < detectionRate
      detectionRate = tempRate;
      galaxyName = "Blazar Galaxy";
  end
  tempRate = CompareQuasar(imgBinary);
  if tempRate < detectionRate
      detectionRate = tempRate;
      galaxyName = "Quasar Galaxy";
  end
  tempRate = CompareSeyfert(imgBinary);
  if tempRate < detectionRate
      detectionRate = tempRate;
      galaxyName = "Seyfret Galaxy";
  end
  tempRate = CompareIrregular(imgBinary);
  if tempRate < detectionRate
      detectionRate = tempRate;
      galaxyName = "Irregular Galaxy";
  end
  detectionRate = 100 - detectionRate;
  if detectionRate < 20
      galaxyName = "Invalid Entry";
  end
  figure;
  imshow(imgGray);

  textX = 10;
  textY = 10;
 
  detectionText = sprintf('Detection Rate: %.2f%%', detectionRate);

  text (textX, textY, galaxyName,'Color','white','FontSize',15);
  text (textX, textY + 50, detectionText, 'Color','white','FontSize',15);
end

function [detectionRate] = CompareSpiral(img)
spiralImg = imread("Spiral_Galaxy-1.jpg");
spiralImg = im2gray(spiralImg);
spiralBinary = imbinarize(spiralImg);

%Masks for Hit or Miss transformations, took the general shapes for the
%galaxies and tried to make them accordingly
lap1 = [
    0 0 0
    1 0 0
    0 1 0
    1 0 1
    1 1 1
    1 1 1
    1 1 1
    0 1 0
    0 0 1
    ];
lap2 = [
    1 1 1
    0 1 1
    1 1 1
    0 1 0
    0 0 0
    0 0 0
    0 0 0
    0 0 0
    1 1 0
    ];

%Applying gaussian filter for smoothing effect
newSpiral = imnoise(double(spiralBinary), 'salt & pepper', 0.7);
newOriginal = imnoise(double(img),'salt & pepper',0.7);

%Variables are no longer binary images and need to be returned to them
%Turn this into a function later
newSpiral = im2gray(newSpiral);
newOriginal = im2gray(newOriginal);

newSpiral = imbinarize(newSpiral);
newOriginal = imbinarize(newOriginal);

newSpiral = HitOrMiss(newSpiral, lap1, lap2);
newOriginal = HitOrMiss(newOriginal, lap1, lap2);
detectionRate = CompareImages(newOriginal, newSpiral);

end

function [detectionRate] = CompareLenticur (img)
lentImg = imread("Lenticular-1.jpg");
lentImg = im2gray(lentImg);
lentBinary = imbinarize(lentImg);

lap1 = [
    0 0 0
    0 1 0
    1 0 1
    0 1 0
    1 0 1
    0 1 0
    0 0 0
    ];
lap2 = [
    1 1 1
    1 0 1
    0 1 0
    1 0 1
    0 1 0
    1 0 1
    1 1 1
    ];

newOriginal = imnoise(im2double(img), 'salt & pepper', 0.7);
newLent = imnoise(im2double(lentBinary), 'salt & pepper',0.7);

newOriginal = im2gray(newOriginal);
newLent = im2gray(newLent);

newLent = imbinarize(newLent);
newOriginal = imbinarize(newOriginal);

newOriginal = HitOrMiss(newOriginal, lap1, lap2);
newLent = HitOrMiss(newLent, lap1, lap2);
detectionRate = CompareImages(newOriginal, newLent);

end

function [detectionRate] = CompareElliptical(img)

elicImg = imread("Elliptical-1.jpg");
elicImg = im2gray(elicImg);
elicBinary = imbinarize(elicImg);

lap1 = [
    0 1 0;
    1 0 1;
    0 1 0
];

lap2 = [
    1 0 1;
    0 1 0;
    1 0 1
];

newOriginal = imnoise(im2double(img), 'salt & pepper',1);
newElic = imnoise(im2double(elicBinary),'salt & pepper',1);

newOriginal = im2gray(newOriginal);
newElic = im2gray(newElic);

newElic = imbinarize(newElic);
newOriginal = imbinarize(newOriginal);

newOriginal = HitOrMiss(newOriginal, lap1, lap2);
newElic = HitOrMiss(newElic, lap1, lap2);
detectionRate = CompareImages(newOriginal, newElic);

end

function [detectionRate] = CompareBlazar(img)

blazImg = imread("Blazar-2.jpg");
blazImg = im2gray(blazImg);
blazBinary = imbinarize(blazImg);

lap1 = [
    0 0 0 0 0 0 0 0 0
    0 0 0 0 0 0 0 0 0
    0 0 0 0 0 0 0 0 0
    0 0 0 0 1 1 1 0 0
    0 0 0 1 1 1 1 0 0
    0 0 1 1 1 1 1 1 0
    0 1 1 1 1 1 1 1 1
    1 1 1 1 1 1 1 1 1
    0 0 0 0 0 0 0 0 0
    ];
lap2 = [
    1 1 1 1 1 1 1 1 1
    1 1 1 1 1 1 1 1 1
    1 1 1 1 1 1 1 1 1
    1 1 1 1 0 0 0 1 1
    1 1 1 0 0 0 0 1 1
    1 1 0 0 0 0 0 0 1
    1 0 0 0 0 0 0 0 0
    0 0 0 0 0 0 0 0 0
    1 1 1 1 1 1 1 1 1
    ];

newOriginal = imnoise(im2double(img), 'salt & pepper', 0.7);
newBlaz = imnoise(im2double(blazBinary), 'salt & pepper', 0.7);

newOriginal = im2gray(newOriginal);
newBlaz = im2gray(newBlaz);

newBlaz = imbinarize(newBlaz);
newOriginal = imbinarize(newOriginal);

newBlaz = HitOrMiss(newBlaz, lap1, lap2);
newOriginal = HitOrMiss(newOriginal, lap1, lap2);

detectionRate = CompareImages(newOriginal, newBlaz);

end

function [detectionRate] = CompareQuasar (img)

quazImg = imread("Quasar-1.jpg");
quazImg = im2gray(quazImg);
quazBinary = imbinarize(quazImg);

lap1 = [
     0 1 1 
     1 1 1
     0 1 0
    ];
lap2 = [
    1 0 0
    0 0 0
    1 0 1
    ];

newOriginal = imnoise(im2double(img),'salt & pepper',0.7);
newQuaz = imnoise(im2double(quazBinary),'salt & pepper',0.7);

newOriginal = im2gray(newOriginal);
newQuaz = im2gray(newQuaz);

newQuaz = imbinarize(newQuaz);
newOriginal = imbinarize(newOriginal);

newQuaz = HitOrMiss(newQuaz, lap1, lap2);
newOriginal = HitOrMiss(newOriginal, lap1, lap2);
detectionRate = CompareImages(newOriginal, newQuaz);

end

function [detectionRate] = CompareSeyfert(img)

seyImg = imread("Seyfert-1.jpg");
seyImg = im2gray(seyImg);
seyBinary = imbinarize(seyImg);

lap1 = [
    0 0 0 0 0
    0 0 0 0 0
    0 0 0 0 0
    0 0 1 0 0
    1 0 0 0 1
    1 0 0 0 1
    0 0 1 0 0
    0 0 0 0 0
];

lap2 = [
    1 1 1 1 1
    1 1 1 1 1
    1 1 1 1 1
    1 1 0 1 1
    0 1 1 1 0
    0 1 1 1 0
    1 1 0 1 1
    1 1 1 1 1
];

newOriginal = imnoise(im2double(img),'salt & pepper',0.7);
newSey = imnoise(im2double(seyBinary),'salt & pepper',0.7);

newOriginal = im2gray(newOriginal);
newSey = im2gray(newSey);

newSey = imbinarize(newSey);
newOriginal = imbinarize(newOriginal);

newOriginal = HitOrMiss(newOriginal, lap1, lap2);
newSey = HitOrMiss(newSey, lap1, lap2);
detectionRate = CompareImages(newOriginal, newSey);
end

function [detectionRate] = CompareIrregular(img)
irreImg1 = imread("Irregular-1.jpg");
irreImg1 = im2gray(irreImg1);
irreImg1 = imnoise(irreImg1,'salt & pepper',0.7);

%used sobel edge detection for irregular due to their lack of defined shape
newOriginal = edge(img,"sobel");
newIrre1 = edge(irreImg1, "sobel");

edgeOrig = sum(newOriginal(:));
edgeIrre = sum(newIrre1(:));

detectionRate = edgeOrig/edgeIrre;
end

function [newOriginal] = HitOrMiss(originalImg, lap1, lap2)

originalFore = imerode(originalImg, lap1);
originalTemp = 1 - originalFore;
originalBack = imerode(originalTemp, lap2);
newOriginal = originalBack .* originalFore;
end

function [detectionRate] = CompareImages(originalImg, Img)
Img = imresize(Img, size(originalImg));
detectionRate = immse(originalImg, Img);
end