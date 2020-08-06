# Diabetic Retinopathy Detection

**Diabetic Retinopathy (DR)** is a disease of retina, which affects patients with diabetes, and it is a main reason for blindness. Its early detection, together with an appropriate treatment, can reduce the risks. 

This project proposes an automatic detector of diabetic retinopathy ba-
sed on the combination of image segmentation, featuring extraction and
binary classification.

The process of detection and segmentation of some lesions of diabetic retinopathy is accomplished by the use of image processing techniques. First, the segmentation of image is carried out, which includes the isolation of blood vessels, hard exudates and microaneurysms. Then the classifier is trained so as to allow the extracted features to classify in normal o DR images.

All functions related to the automatic detection of diabetic retinopathy have been implemented with the help of **MATLAB**, one of the most powerful image processing tools which, thanks to the power and versatility of its images processing toolbox, simplifies the implementations of the algorithms.

## Method

The input retinal images undergo segmentation to detect blood vessels, exudates and microaneurysms separately, according to processes that are effectively descripted by mathematical formulations. 

In the RGB images, the green channel exhibits the strongest contrast between the vessels and the background, while the red and blue ones tend to be noisier. Due to this reason, for the segmentation of **retinal blood vessels**, Contrast-Limited Adaptive Histogram Equalization (CLAHE) is initially applied on this channel. Then, intensity is normalized by expanding through its range, on this image a median filter is used to obtain a background image that will be subtracted from the previous one. A threshold estimated with the Otsu’s method is applied to this image to achieve a binary image. Afterwards, a closing with a linear structuring element is applied to accentuate the vessels, in addition to eliminate the small connected elements, in order to remove the noises contained in the binary image.

| ![Automatic detection of retinal blood vessels.](https://github.com/MarAl15/DiabeticRetinopathyDetection/blob/master/images/blood_vessels.png) |
|:--:|
| *Automatic detection of retinal blood vessels.* |

**Hard exudates** are yellow flecks made up of lipid residues. Such exudates cause clear lesions, so they can be detected from the red channel on which the Toh-Hat transform with disk-shaped structuring element is applied to obtain the bright components, and then the circular edge is removed. The maximum entropy method is used to achieve a thresholded image and, finally, the remaining parts of blood vessels and optic disc are extracted out of it.

| ![Edge detection in retinal fundus images.](https://github.com/MarAl15/DiabeticRetinopathyDetection/blob/master/images/circular_edge.png) |
|:--:|
| *Edge detection in retinal fundus images.* |

| ![Optic disc detection in retinal fundus images.](https://github.com/MarAl15/DiabeticRetinopathyDetection/blob/master/images/optic_disc.png) |
|:--:|
| *Optic disc detection in retinal fundus images.* |

| ![Automatic detection of hard exudates in retinal images.](https://github.com/MarAl15/DiabeticRetinopathyDetection/blob/master/images/hard_exudates.png) |
|:--:|
| *Automatic detection of hard exudates in retinal images.* |

**Microaneurysms** are the first clinical sign of diabetic retinopathy and they appear as small red dots on retinal fundus images. First of all, a gray-scale image is created from the green and red channel. A median filter is applied and the resulting image is subtracted from the gray image. CLAHE is used for contrast enhancement, and the gray threshold is selected from Otsu’s method and a error-correction factor. Then we extract anatomical structures such as blood vessels and exudates. Microaneurysms are dark-reddish in colour and appear as small red dots of 10-to-100 microns of diameter and, as they are circular in shape, we select the circular elements whose radius are contained in the interval.

| ![Automatic detection of microaneurysms in retinal images.](https://github.com/MarAl15/DiabeticRetinopathyDetection/blob/master/images/microaneurysms.png) |
|:--:|
| *Automatic detection of microaneurysms in retinal images.* |

Texture means repeating patterns of local variation of pixel intensities. It gives information about the arrangement of surface pixels and their relationship with the surrounding pixels. The features given to the classifier include neither only the areas of these segmented structures or these areas and textural features obtained based on **Gray Level Co-occurrence Matrix (GLCM)**. These features are the area of blood vessels, area of exudates, area of microaneurysms, contrast, homogeneity, correlation and energy. 
Area of blood vessels is determined by finding the total number of white (vessel) pixel in the vessel-segmented image. Similarly, the area of exudates and microaneurysms are determined by finding the number of white pixels in the exudates image and microaneurysms image respectively. On the other hand, contrast, homogeneity, correlation and energy are the commonly extracted textural features from GLCM.

In this work, it was decided to make a comparison between **decision tree** and **Support Vector Machine (SVM)** classifier with different kernels.

The **5-fold cross-validation** is applied to verify the reliability of results we can obtain, evaluating the efficiency based on parameters of sensitivity, specificity and accuracy.

The 5-fold cross-validation is applied to verify the reliability of results we can obtain, evaluating the efficiency based on parameters of sensitivity, specificity and accuracy.
