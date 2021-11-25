# _Custom HOG Descriptor_

## About/Overview:
✨This is a mini-project, an implementation of "Navneet Dalal, Bill Triggs's Histograms of Oriented Gradients for Human Detection" in matlab.✨

### Objective: 
To analyze any given image and classify if the image is of a person or not. This method is based on evaluating well-normalized local histograms of image gradient orientations in a dense grid. <br>
**Expected Output:** The algorithm will be able to detectt pedestrians frfom pictures with various backgrounds, brightness levels and pose variations.

## Dataset:

Dataset Name: INRIA Person Dataset
Source:  http://pascal.inrialpes.fr/data/human/  <br>
The data set contains images from several different sources: <br>
    - Images from [GRAZ 01](http://www.emt.tugraz.at/~pinz/data/GRAZ_01/) dataset, though annotation files are completely new. <br>
Images from personal digital image collections taken over a long time period. Usually the original positive images were of very high resolution (approx. 2592x1944 pixels), so they have cropped these images to highlight persons. Many people are bystanders taken from the backgrounds of these input photos, so ideally there is no particular bias in their pose <br>

## Approach:
Initially, the input image is taken and the colour and gamma values are normalized. The gradients of this
image are computed and are weight voted into spatial and orientation cells. The contrast of the
overlapping spatial blocks are normalized.

The HOG’s are collected over detection window and linear SVM is applied which is used to
classify the image as a person/ non-person.
