clear all;
close all;
clc;

srcFiles = dir('Y:\INRIAPerson\INRIAPerson\test_64x128_H96\pos\*.png');
for i = 1 : 400
    filename = strcat('Y:\INRIAPerson\INRIAPerson\test_64x128_H96\pos\',srcFiles(i).name);

    image = imread(filename);
    image = imresize(image, [128 64]);
    bw = rgb2gray(image);   %Convert RGB image to gray scale image
    bw = double(bw)./255;
    label=1;

    feature_vector=hog_custom(bw);
    I(1:3780,i)=feature_vector;
    I(3781,i)=label;
    %Mdl=fitcsvm(feature_vector,label);
end

srcFiles2 = dir('Y:\INRIAPerson\INRIAPerson\Train\neg\*.jpg');
for i = 1 : 200
    filename = strcat('Y:\INRIAPerson\INRIAPerson\Train\neg\',srcFiles2(i).name);
    imagen = imread(filename);
    imagen = imresize(imagen, [128 64]);
    bw1 = rgb2gray(imagen);   %Convert RGB image to gray scale image
    bw1 = double(bw1)./255;
    labeln=0;
    feature_vector_neg=hog_custom(bw1);
    I(1:3780,i+400)=feature_vector_neg;
    I(3781,i+400)=labeln;
    %Mdl=fitcsvm(feature_vector_neg,labeln);
end
Y=I(3781,:);
Mdl=fitcsvm(I(1:3780,:)',Y);

