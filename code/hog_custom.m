function[hog3] = hog_custom(bw)
% image = imread('p15.png');
% image = imresize(image, [128 64]);
% bw = rgb2gray(image);   %Convert RGB image to gray scale image
% bw = double(bw)./255;   %Normalize image

%Initialization of Matrices
Gx = zeros(size(bw));
Gy = zeros(size(bw));
Gmag = zeros(size(bw));
Gdir = zeros(size(bw));
gx = [-1 0 1];  %x gradient
gy = [-1;0;1];  %y gradient
kernal = ones(8,8); %Temporary matrix used in voting
hog = zeros(128,9); %empty HOG vector
hog1 = zeros(16,72);
hog2 = zeros(105,36);
hog_norm = zeros(size(hog));
cnt = 1;
cnt1 = 1;
m = 1;

% Gradient in x - direction
for i = 1:128
    for j = 1:64
        if j == 1   %leftmost pixel special case
            Gx(i,j) = sum(bw(i,j:j+1).*gx(1,1:2));
        elseif j == 64  %rightmost pixel special case
            Gx(i,j) = sum(bw(i,j-1:j).*gx(1,2:3));
        else    %remaining pixels
            Gx(i,j) = sum(bw(i,j-1:j+1).*gx);
        end
    end
end

% Gradient in y - direction
for i = 1:128
    for j = 1:64
        if i == 1   %leftmost pixel special case
            Gy(i,j) = sum(bw(i:i+1,j).*gy(2:3));
        elseif i == 128 %rightmost pixel special case
            Gy(i,j) = sum(bw(i-1:i,j).*gy(1:2));
        else    %remaining pixels
            Gy(i,j) = sum(bw(i-1:i+1,j).*gy);
        end
    end
end

% Gradient Magnitude & Direction
for i = 1:128
    for j = 1:64
        Gmag(i,j) = sqrt((Gx(i,j)^2)+(Gy(i,j))^2);
        c = atand(Gy(i,j)/Gx(i,j));
        c(isnan(c)) = 0;    %make the value zero if c equals NaN 
        if c < 0    %all angles in eange 0 to 180
            c = 180 + c;
        end
        Gdir(i,j) = c;
    end
end

% HOG calculation for each cell(8x8 pixels)
for i = 1:8:128
    for j = 1:8:64
        tempm = kernal.*Gmag(i:i+7,j:j+7); % Extracting 8x8 matrix from Gmag matrix
        tempd = kernal.*Gdir(i:i+7,j:j+7); % Extracting 8x8 matrix from Gdir matrix
        
        for k = 1:8 % Voting for each cell of size 8x8
            for l = 1:8
                lower = floor(norm(tempd(k,l))./20); %Rounding off to the lowest (divide by 20 because bin size is 20)
                upper = ceil(norm(tempd(k,l))./20);  %Rounding off to the highest
                temp = norm(tempd(k,l))./20;         %Actual value
             %interpolating the values into bins (0 to 160) in steps of 20
                if temp > 8 %for value greater than 160 degrees, interpolating between 0 and 160 bin
                    hog(cnt,1) = hog(cnt,1) + (temp - lower).*tempm(k,l); %lower bin - Gmag values
                    hog(cnt,lower+1) = hog(cnt,lower+1) + (upper - temp).*tempm(k,l); %upper bin - Gmag values
                else
                    hog(cnt,upper+1) = hog(cnt,upper+1) + (temp - lower).*tempm(k,l);
                    hog(cnt,lower+1) = hog(cnt,lower+1) + (upper - temp).*tempm(k,l);
                end
            end
        end
        cnt = cnt + 1;
    end
end

% Gradient in X and Y and Original Image
% subplot(1,3,1);
% imshow(bw);
% subplot(1,3,2);
% imshow(Gx);
% subplot(1,3,3);
% imshow(Gy);
% 
% % Plot of Gmag and Gdir
% figure(2)
% subplot(1,2,1)
% imshow(Gmag);
% subplot(1,2,2);
% imshow(Gdir);
% 
% Normalization
for i = 1:128
    val = sqrt(sum((hog(i,:).^2)));
    temp = hog(i,:)./val;
    temp(isnan(temp)) = 0;
    hog_norm(i,:) = temp;
end
    
%Block Normalization
for j = 1:8:128 %creating a 16x8 matrix made up of 8x8 cells (16x[8x9]) - vector
    hog1(cnt1,:) = [hog_norm(j,:) hog_norm(j+1,:) hog_norm(j+2,:) hog_norm(j+3,:) hog_norm(j+4,:) hog_norm(j+5,:) hog_norm(j+6,:) hog_norm(j+7,:)]; 
    cnt1 = cnt1 + 1;
end

%Normalizing the 16x16 blocks and concatenating them to from 36x1 vectors
for i = 1:15 
    for j = 1:9:55
        hog2(m,:) = [hog1(i,j:j+8) hog1(i,j+9:j+17) hog1(i+1,j:j+8) hog1(i+1,j+9:j+17)];
        m = m + 1;
    end
end

% 3780x1 vector formed by concatenation of 36x1 vectors
hog3 = hog2(1,:);
for i = 2:105
    hog3 = horzcat(hog3,hog2(i,:));
end
