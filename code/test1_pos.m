srcFiles4 = dir('Y:\INRIAPerson\INRIAPerson\Test\pos\*.png');
for i = 1 : 200
    filename2 = strcat('Y:\INRIAPerson\INRIAPerson\Test\pos\',srcFiles4(i).name);
    image1 = imread(filename2);
    image1 = imresize(image1, [128 64]);
    bw2 = rgb2gray(image1);   %Convert RGB image to gray scale image
    bw2 = double(bw2)./255;
    feature_vector3=hog_custom(bw2);
    prediction(i)=predict(Mdl,feature_vector3);
end
