fixedPoints='data/pointsLowerLeft.nii.gz'
movingPoints='data/pointsUpperRight.nii.gz'
ImageMath 2 data/pointsLowerLeftP.nii.gz PadImage \
  data/pointsLowerLeft.nii.gz 50
ImageMath 2 data/pointsUpperRightP.nii.gz PadImage \
  data/pointsUpperRight.nii.gz 50
fixedPoints='data/pointsLowerLeftP.nii.gz'
movingPoints='data/pointsUpperRightP.nii.gz'
outputDirectory='./'
outputPrefix=${outputDirectory}/diffeomorphismTest
s=1 # sampling rate
k=5 # k - neighborhood
antsRegistration -d 2 \
                 -o ${outputPrefix} \
                 -x [${fixedPoints},${movingPoints}] \
                 -m PSE[${fixedPoints},${movingPoints},1,${s},0,25,$k] \
                 -t BSplineSyN[0.5,1x1,0,5] \
                 -c [200x200x200x200x50,0,10] \
                 -s 0x0x0x0x0 \
                 -f 8x8x4x2x1
 antsApplyTransforms -d 2 \
                     -o ${outputPrefix}Warped.nii.gz \
                     -i ${movingPoints} \
                     -r ${fixedPoints} \
                     -n NearestNeighbor \
                     -t ${outputPrefix}0Warp.nii.gz

CreateWarpedGridImage 2 ${outputPrefix}0Warp.nii.gz ${outputPrefix}WarpedGrid.nii.gz
