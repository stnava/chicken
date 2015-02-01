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
                 -m PSE[${fixedPoints},${movingPoints},1,${s},0,55,$k] \
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

exit

#########################################################
outputPrefix=oldANTs
tx=" -r Gauss[6,0.75] -t SyN[1,4,0.05] -i 191x170x90x1x1 "
ANTS 2 $tx   -m PSE[ data/pointsLowerLeftP.nii.gz , data/pointsUpperRightP.nii.gz ,data/pointsLowerLeftP.nii.gz , data/pointsUpperRightP.nii.gz , 1, 0.1, 10, 0,1, 0] -o ${outputPrefix}  --continue-affine 0 --number-of-affine-iterations 0 --geodesic 2
CreateWarpedGridImage 2 ${outputPrefix}Warp.nii.gz ${outputPrefix}Grid.nii.gz
antsApplyTransforms -d 2 \
                    -o ${outputPrefix}Warped.nii.gz \
                    -i data/pointsUpperRightP.nii.gz \
                    -r data/pointsLowerLeftP.nii.gz \
                    -n NearestNeighbor \
                    -t ${outputPrefix}Warp.nii.gz
