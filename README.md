chicken
=======

a global optimization example + landmark distances performed with [ITK](http://www.itk.org.) and [ANTs](http://stnava.github.io/ANTs/ "ANTs")


Global optimization.

`antsAffineInitializer 2 chicken-4.jpg chicken-3.jpg chicken3to4.mat 10  0.3 0 10`


`antsApplyTransforms -d 2 -i chicken-3.jpg -o test.nii.gz -r chicken-4.jpg -t chicken3to4.mat `
`antsApplyTransforms -d 2 -i chicken-3-seg.nii.gz -o chicken-3-segw.nii.gz -r chicken-4.jpg -t chicken3to4.mat -n NearestNeighbor `
`ImageMath 2 chicken-3.csv LabelStats chicken-3-seg.nii.gz chicken-3-seg.nii.gz `
`ImageMath 2 chicken-3w.csv LabelStats chicken-3-segw.nii.gz chicken-3-segw.nii.gz `
`antsApplyTransformsToPoints -d 2 -i chicken-3.csv -o test.csv -t [chicken3to4.mat ,1 ]`

