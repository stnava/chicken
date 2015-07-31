chicken
=======

a global optimization example + landmark distances performed with [ITK](http://www.itk.org.) and [ANTs](http://stnava.github.io/ANTs/ "ANTs")


Global optimization. You may need to change the parameters for your own application. 

See the code [here](https://github.com/stnava/ANTs/blob/master/Examples/antsAffineInitializer.cxx) which uses ITK multi-start optimization

`antsAffineInitializer 2 chicken-4.jpg chicken-3.jpg chicken3to4.mat 10  0.3 0 10`

Now apply the results to warp the images and the labels.

`antsApplyTransforms -d 2 -i chicken-3.jpg -o test.nii.gz -r chicken-4.jpg -t chicken3to4.mat `

`antsApplyTransforms -d 2 -i chicken-3-seg.nii.gz -o chicken-3-segw.nii.gz -r chicken-4.jpg -t chicken3to4.mat -n NearestNeighbor `

Now convert to csv files to take a look at point-wise results.

`ImageMath 2 chicken-3.csv LabelStats chicken-3-seg.nii.gz chicken-3-seg.nii.gz `

`ImageMath 2 chicken-3w.csv LabelStats chicken-3-segw.nii.gz chicken-3-segw.nii.gz `

Transform the points.

`antsApplyTransformsToPoints -d 2 -i chicken-3.csv -o test.csv -t [chicken3to4.mat ,1 ]`

And compare - test.csv should be similar to chicken-3w.csv ... 


The example images are here:


![Chicken-3](https://github.com/stnava/chicken/blob/master/data/chicken-3.jpg?raw=true)

![Chicken-4](https://github.com/stnava/chicken/blob/master/data/chicken-4.jpg?raw=true)


