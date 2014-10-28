fixedPoints='data/chicken-4.nii.gz'
movingPoints='data/chicken-3.nii.gz'

outputDirectory='./'
outputPrefix=${outputDirectory}/pseChicken4xChicken3
s=0.1 # sampling rate
k=10 # k - neighborhood
antsRegistration -d 2 \
                 -o ${outputPrefix} \
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
                 -x [${fixedPoints}]

 antsApplyTransforms -d 2 \
                     -o ${outputPrefix}Warped.nii.gz \
                     -i ${movingPoints} \
                     -r ${fixedPoints} \
                     -n NearestNeighbor \
                     -t ${outputPrefix}0GenericAffine.mat
