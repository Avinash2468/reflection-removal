# Project Proposal 




## Project Id and title

18 - Reflection Removal using Ghosting Cues

## Github link
https://github.com/Digital-Image-Processing-IIITH/project-framed

## Team Members

 - Mallika Subramanian
 - Fiza Husain
 - Avinash Prabhu
 - Tanvi Karandikar

## The main goal(s) of the project
Primary goal of the project is to implement an algorithm that performs post-processing on the images to remove reflection artifacts. The important property that is leveraged here is the ghosting cues that arise from double shifted reflections of the reflected scene off the glass surface.

## Problem definition (What is the problem? How things will be done ?)
When taking photographs through windows or glass panes, reflections of the scene on the same side of the glass as the camera often ruin the picture. We can remove the artifacts due to the reflection by using image processing techniques to recover both the image and the reflected component.

The paper defines a loss function which needs to be optimised. It takes in two known variables *I* and *k* and gives an output as two images, *T* and *R*. Where:

*I* = input image

*T* = transmission component

*R* = reflection component

*k* = convolution kernel

The project has two parts to it.

Part 1: Estimation of *k*. This uses techniques of autocorrelation.

Part 2: Estimation of *T* and *R* which give the minimum value for the function defined. The function uses *I* and *k* as known constants.

## Results of the project (What will be done? What is the expected final result ?)
The result of the project will be an algorithm which will demonstrate how ghosting cues help in the recovery of transmission and reflection layers.

Expected final result is to demonstrate potential applications of our algorithm.


## What are the project milestones and expected timeline?
**31st October:**

1. Find <img src="https://render.githubusercontent.com/render/math?math=c_k"> and <img src="https://render.githubusercontent.com/render/math?math=d_k">.

2. Study and gather resources necessary for part 2 of the projet: GMM pre-trained model, ADMM optimization method.

**18th November:** 

Final deliverable

## Is there a dataset you need? How do you plan to get it?
Dataset- We need a dataset to test the effectiveness of our algorithm. The authors of the paper have provided the synthetic dataset they generated-
https://github.com/thongnguyendev/single_image/tree/master/release/synthetic_data

We can also get images by searching off of google images.

