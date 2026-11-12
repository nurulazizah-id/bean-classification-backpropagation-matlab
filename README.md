# bean-classification-backpropagation-matlab
Classification of Bean Types Using the Backpropagation Method Based on Shape, Color, and Texture Feature Extraction
<img width="258" height="346" alt="image" src="https://github.com/user-attachments/assets/6642c31a-ef6b-4a76-8bd1-f23c4fefdbb1" />

Research Stages
This research consists of the following stages:
1.	Observation
Observing five types of beans: chickpeas, ginkgo beans, sword beans, pistachios, and cowpeas based on their shape, color, and texture.
2.	Problem Analysis
Identifying the differences in the characteristics of each bean type as the basis for the classification process.
3.	Literature Review
Collecting information from journals and previous studies related to image processing and classification methods.
4.	Data Collection
Collecting 750 bean images, which are divided into training and testing data using three ratios: 80:20, 70:30, and 60:40.
5.	Pre-processing
Resizing each image to 350 × 350 pixels, reducing noise using a median filter, and converting the image into different color spaces.
6.	Segmentation
Separating the bean object from the background using the Otsu Thresholding method to prepare the image for feature extraction.
7.	Feature Extraction
Extracting 13 image features, consisting of 5 shape features, 6 HSV color features, and 2 texture features using Local Binary Pattern (LBP).
8.	Backpropagation Implementation
Training an Artificial Neural Network using the extracted features to recognize and classify the five types of beans.
9.	System Testing
Testing the GUI application to evaluate its ability to classify bean types and measure its classification accuracy.

<img width="893" height="464" alt="image" src="https://github.com/user-attachments/assets/dafaadab-2efb-4f65-8ddc-0034c9573506" />

Explanation of Push Button Functions
This application has 11 push buttons that are used to process images and classify different types of beans. Each button has a specific function, as explained below:
1. Input Image
Used to select an image from the File Explorer. The selected image will be displayed in Axes 1.
2. Median Filter
Used to remove noise from the image and make it clearer. The result will be displayed in Axes 2.
3. Grayscale Image
Converts the original RGB image into a black-and-white image (grayscale) to prepare it for segmentation. The result will be displayed in Axes 3.
4. Segmentation
Separates the bean object from the background using the Otsu Thresholding method. The result will be displayed in Axes 4.
5. HSV Color Space
Converts the image into the HSV color space to help extract color features. The result will be displayed in Axes 5.
6. Graythresh
Processes the grayscale image to support texture feature extraction. The result will be displayed in Axes 6.
7. Shape Feature Extraction
Extracts the bean's shape features, including area, perimeter, minor axis, major axis, and eccentricity. The results will be displayed in the Edit Text fields.
8. Color Feature Extraction
Extracts color features using the Mean and Standard Deviation values of Hue, Saturation, and Value.
9. Texture Feature Extraction
Uses the Local Binary Pattern (LBP) method to extract texture features, including LBP Mean and LBP Standard Deviation.
10. Classification
Classifies the image using the Backpropagation method to identify the type of bean. The possible results are chickpeas, ginkgo beans, sword beans (koro binong), pistachios, and cowpeas. The classification result will appear in the classification panel.
11. Reset
Returns the application to its initial screen, allowing users to upload and process a new image.
Overall, this application works through several stages: image input, pre-processing, segmentation, shape, color, and texture feature extraction, followed by classification to identify the type of bean.

## Dataset

The image dataset used in this research can be downloaded through the following link:

[Download Dataset](https://www.kaggle.com/datasets/nurulazizahacha/seed-image-dataset-with-similar-objects)

The dataset consists of 750 images from five types of beans: chickpeas, ginkgo beans, sword beans, pistachios, and cowpeas.

**Note:** The uploaded dataset has not been divided into training and testing data. If you want to test or reproduce this research, please manually split the dataset on your local device using one of the following ratios:

- 80:20 (80% training data and 20% testing data)
- 70:30 (70% training data and 30% testing data)
- 60:40 (60% training data and 40% testing data)

Please make sure that the images are properly organized into training and testing folders before running the classification process.

Important: Test Image Folder Location
Before running the MATLAB code, make sure to adjust the image folder path according to the location where your test images are stored on your computer.

For example:
image_folder = 'D:\backup data skripsi\programskripsi\datalatih80';

Note: The folder path above is an example from the original researcher's device. You must change it to match your own folder location. Make sure the folder contains the test images (.jpg) before running the code.


ujild.m uses images of bean types outside the five main classes to evaluate the system's ability to detect and classify unknown objects as "Unknown."
