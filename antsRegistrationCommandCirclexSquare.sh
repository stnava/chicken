fixedPoints='data/circles.nii.gz'
movingPoints='data/squares.nii.gz'

outputDirectory='./'
outputPrefix=${outputDirectory}/circlesxSquares
s=1 # sampling rate
k=10 # k - neighborhood
antsRegistration -d 2 -v 1 \
                 -o ${outputPrefix} \
                 -x [${fixedPoints},${movingPoints}] \
                 -r [${fixedPoints},${movingPoints},1] \
                 -m PSE[${fixedPoints},${movingPoints},1,${s},1,20,$k] \
                 -t Affine[0.1] \
                 -c [50,0,10] \
                 -s 0 \
                 -f 1 \
                 -m PSE[${fixedPoints},${movingPoints},1,${s},1,10,$k] \
                 -t Affine[0.1] \
                 -c [40,0,10] \
                 -s 0 \
                 -f 1 \
                 -m PSE[${fixedPoints},${movingPoints},1,${s},1,5,$k] \
                 -t Affine[0.1] \
                 -c [20,0,10] \
                 -s 0 \
                 -f 1 \
                 -m PSE[${fixedPoints},${movingPoints},1,${s},1,20,$k] \
                 -t SyN[0.2,6,0] \
                 -c [100x100x100,0,10] \
                 -s 0x0x0 \
                 -f 3x2x1

 antsApplyTransforms -d 2 -v 1 \
                     -o ${outputPrefix}Warped.nii.gz \
                     -i ${movingPoints} \
                     -r ${fixedPoints} \
                     -n NearestNeighbor \
                     -t ${outputPrefix}1Warp.nii.gz \
                     -t ${outputPrefix}0GenericAffine.mat
