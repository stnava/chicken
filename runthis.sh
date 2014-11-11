
antsAffineInitializer 2 data/chicken-4.jpg data/chicken-3.jpg chicken3to4.mat 10 0.3 0 10

antsApplyTransforms -d 2 -i data/chicken-3.jpg -o test.nii.gz -r data/chicken-4.jpg -t chicken3to4.mat 

antsApplyTransforms -d 2 -i data/chicken-3-seg.nii.gz -o chicken-3-segw.nii.gz -r data/chicken-4.jpg -t chicken3to4.mat -n NearestNeighbor 

ImageMath 2 chicken-3.csv LabelStats data/chicken-3-seg.nii.gz data/chicken-3-seg.nii.gz 

ImageMath 2 chicken-3w.csv LabelStats chicken-3-segw.nii.gz chicken-3-segw.nii.gz 

antsApplyTransformsToPoints -d 2 -i chicken-3.csv -o test.csv -t [chicken3to4.mat ,1 ]


# these should produce identical output, up to file format
antsApplyTransformsToPoints -d 2 -i ./data/chicken-3-ref.csv -o testq2.csv -t [ data/chicken3to4-ref.mat , 1]
antsApplyTransformsToPoints -d 2 -i ./data/chicken-3-ref.mha -o testq2.mha -t [ data/chicken3to4-ref.mat , 1]


