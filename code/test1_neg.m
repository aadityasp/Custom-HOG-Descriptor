srcFiles3 = dir('Y:\INRIAPerson\INRIAPerson\Test\neg\*.jpg');
for i = 1 : 100
    filename2 = strcat('Y:\INRIAPerson\INRIAPerson\Test\neg\',srcFiles3(i).name);
    image2 = imread(filename2);
    image2 = imresize(image2, [128 64]);
    bw3 = rgb2gray(image2);   %Convert RGB image to gray scale image
    bw3 = double(bw3)./255;
    feature_vector3=hog_custom(bw3);
    prediction(i)=predict(Mdl,feature_vector3);
end   
    
 