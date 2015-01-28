fixedPoints='data/pointsLowerLeft.nii.gz'
movingPoints='data/pointsUpperRight.nii.gz'

outputDirectory='./'
outputPrefix=${outputDirectory}/diffeomorphismTest
s=1 # sampling rate
k=3 # k - neighborhood
antsRegistration -d 2 \
                 -o ${outputPrefix} \
                 -x [${fixedPoints},${movingPoints}] \
                 -m PSE[${fixedPoints},${movingPoints},1,${s},0,10,$k] \
                 -t BSplineSyN[0.1,10x10,0] \
                 -c [100x100,0,10] \
                 -s 0 \
                 -f 2x1

 antsApplyTransforms -d 2 \
                     -o ${outputPrefix}Warped.nii.gz \
                     -i ${movingPoints} \
                     -r ${fixedPoints} \
                     -n NearestNeighbor \
                     -t ${outputPrefix}0Warp.nii.gz

CreateWarpedGridImage 2 ${outputPrefix}0Warp.nii.gz ${outputPrefix}WarpedGrid.nii.gz