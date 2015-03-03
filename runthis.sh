
ImageMath 2 chicken4fixed.nii.gz PadImage data/chicken-4.jpg 10
SetDirectionByMatrix chicken4fixed.nii.gz chicken4fixed.nii.gz -0.259 -0.966 0.966 -0.259
SetOrigin 2 chicken4fixed.nii.gz chicken4fixed.nii.gz -25 25

antsAffineInitializer 2 chicken4fixed.nii.gz data/chicken-3.jpg  chicken3to4.mat 10 1.0 0 50

antsApplyTransforms -d 2 -i data/chicken-3.jpg  -o test.nii.gz -r chicken4fixed.nii.gz -t chicken3to4.mat -n NearestNeighbor

antsApplyTransforms -d 2 -i data/chicken-3-seg.nii.gz -o chicken-3-segw.nii.gz -r chicken4fixed.nii.gz -t chicken3to4.mat -n NearestNeighbor

ImageMath 2 chicken-3.csv LabelStats data/chicken-3-seg.nii.gz data/chicken-3-seg.nii.gz

ImageMath 2 chicken-3w.csv LabelStats chicken-3-segw.nii.gz chicken-3-segw.nii.gz

antsApplyTransformsToPoints -d 2 -i chicken-3.csv -o test.csv -t [chicken3to4.mat ,1 ]

antsApplyTransformsToPoints -d 2 -i test.csv -o testinv.csv -t chicken3to4.mat
#
# validation 1
# testinv.csv should be the same as chicken-3.csv
cat chicken-3.csv testinv.csv
#
# validation 2
# test.csv should be close to chicken-3w.csv
cat chicken-3w.csv test.csv


# these should produce identical output, up to file format
antsApplyTransformsToPoints -d 2 -i ./data/chicken-3-ref.csv -o testq2.csv -t [ data/chicken3to4-ref.mat , 1]
antsApplyTransformsToPoints -d 2 -i ./data/chicken-3-ref.mha -o testq2.mha -t [ data/chicken3to4-ref.mat , 1]

# a manual example
ANTSUseLandmarkImagesToGetAffineTransform data/chicken-3-seg.nii.gz data/chicken-4-seg.nii.gz affine aff.txt
antsApplyTransforms -d 2 -i data/chicken-4.nii.gz -o /tmp/chk.nii.gz -t aff.txt -r data/chicken-3.nii.gz
ImageMath 2 chicken-3.csv LabelStats data/chicken-3-seg.nii.gz data/chicken-3-seg.nii.gz
ImageMath 2 chicken-4.csv LabelStats data/chicken-4-seg.nii.gz data/chicken-4-seg.nii.gz
antsApplyTransformsToPoints -d 2 -i chicken-4.csv -o /tmp/chk.csv -t [aff.txt,1]
