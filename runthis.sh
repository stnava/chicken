
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

# now repeat the above using a multi-start affine followed by a deformable map
fixed=chicken4fixed.nii.gz
moving=data/chicken-3.jpg
antsAI -d 2 -m Mattes[ $fixed, $moving, 32, Regular, 0.5 ] \
  -t Affine \
  -p 0 \
  -s [10,1] \
  -c [100,1.e-6,10] \
  -o antsAI_Map.mat -v 1
antsApplyTransforms -d 2 -i $moving  -o test.nii.gz -r $fixed \
  -t antsAI_Map.mat -n NearestNeighbor
antsRegistration -d 2 -r antsAI_Map.mat \
  -o [ antsAI_SyN_Map, antsAI_SyN_MapWarped.nii.gz ] \
  -n NearestNeighbor \
  -t SyN[0.1] \
  -m cc[ $fixed, $moving, 1, 2 ] \
  -c 100x100x0 \
  -f 4x2x1 \
  -s 2x1x0

# now map the chicken 3 points to the chicken4w space
antsApplyTransformsToPoints -d 2 -i chicken-3.csv -o testsyn.csv -t [antsAI_Map.mat ,1 ] -t antsAI_SyN_Map1InverseWarp.nii.gz


# the mapped chicken 3 points should be close to the chicken 4 points
ImageMath 2 chicken-4-segw.nii.gz PadImage data/chicken-4-seg.nii.gz 10
SetDirectionByMatrix chicken-4-segw.nii.gz chicken-4-segw.nii.gz -0.259 -0.966 0.966 -0.259
SetOrigin 2 chicken-4-segw.nii.gz chicken-4-segw.nii.gz -25 25
ImageMath 2 chicken-4w.csv LabelStats chicken-4-segw.nii.gz chicken-4-segw.nii.gz

# compare
cat chicken-4w.csv
cat test.csv
cat testsyn.csv # should be closer to chicken-4w.csv than test.csv
# in my experiments testsyn.csv contains:
# x,y,z,t,label,mass,volume,count
# -177.974,3.92814,0,0,1,76,76,76
# -80.8545,26.1452,0,0,2,152,76,76
# -313.395,38.816,0,0,3,132,44,44
# -179.13,114.43,0,0,4,176,44,44
# -267.311,138.4,0,0,5,220,44,44
# -220.739,211.601,0,0,6,264,44,44


exit

# a manual example
ANTSUseLandmarkImagesToGetAffineTransform data/chicken-3-seg.nii.gz data/chicken-4-seg.nii.gz affine aff.txt
antsApplyTransforms -d 2 -i data/chicken-4.nii.gz -o /tmp/chk.nii.gz -t aff.txt -r data/chicken-3.nii.gz
ImageMath 2 chicken-3.csv LabelStats data/chicken-3-seg.nii.gz data/chicken-3-seg.nii.gz
ImageMath 2 chicken-4.csv LabelStats data/chicken-4-seg.nii.gz data/chicken-4-seg.nii.gz
antsApplyTransformsToPoints -d 2 -i chicken-4.csv -o /tmp/chk.csv -t [aff.txt,1]
