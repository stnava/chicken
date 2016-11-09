fixedPoints='data/pointsLowerLeft.nii.gz'
movingPoints='data/pointsUpperRight.nii.gz'
ImageMath 2 data/pointsLowerLeftP.nii.gz PadImage \
  $fixedPoints 50
ImageMath 2 data/pointsUpperRightP.nii.gz PadImage \
  $movingPoints 50
fixedPoints='data/pointsLowerLeftP.nii.gz'
movingPoints='data/pointsUpperRightP.nii.gz'
outputDirectory='./'
outputPrefix=${outputDirectory}/diffeomorphismTest
s=1 # sampling rate
k=5 # k - neighborhood
txs="SyN[0.25,6,0.0]"
txb="BSplineSyN[0.2,2x2,0,5]"
tx=$txb
time antsRegistration -d 2 \
                 -o ${outputPrefix} \
                 -x [${fixedPoints},${movingPoints}] \
                 -m PSE[${fixedPoints},${movingPoints},1,${s},0,50,$k] \
                 -t $tx \
                 -c [200x200x200x200x50,0,10] \
                 -s 0x0x0x0x0 \
                 -f 8x8x4x2x1

antsApplyTransforms -d 2 \
                     -o ${outputPrefix}Warped.nii.gz \
                     -i ${movingPoints} \
                     -r ${fixedPoints} \
                     -n NearestNeighbor \
                     -t ${outputPrefix}0Warp.nii.gz
#
antsApplyTransforms -d 2 \
                    -o ${outputPrefix}InvWarped.nii.gz \
                    -i ${fixedPoints} \
                    -r ${movingPoints} \
                    -n NearestNeighbor \
                    -t ${outputPrefix}0InverseWarp.nii.gz

ImageMath 2 ${outputPrefix}invid.nii.gz InvId ${outputPrefix}0InverseWarp.nii.gz ${outputPrefix}0Warp.nii.gz

CreateWarpedGridImage 2 ${outputPrefix}0Warp.nii.gz ${outputPrefix}Grid.nii.gz

CreateWarpedGridImage 2 ${outputPrefix}0InverseWarp.nii.gz ${outputPrefix}InvGrid.nii.gz
# now visualize with snap
#  snap -g diffeomorphismTestGrid.nii.gz -s diffeomorphismTestWarped.nii.gz
