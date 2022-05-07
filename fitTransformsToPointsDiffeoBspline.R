library( ANTsR )
library( patchMatchR )
fixedPoints='data/pointsLowerLeftP.nii.gz'
movingPoints='data/pointsUpperRightP.nii.gz'
circ = antsImageRead( fixedPoints, dimension=2 )
squar = antsImageRead( movingPoints, dimension=2 )

cpts = getCentroids(circ)[,1:2]
spts = getCentroids(squar)[,1:2]

txlist = list()
newpts = cpts
for ( j in 1:10 ) {
  fit = fitTransformToPairedPoints(
    spts,
    data.matrix(newpts),
    transformType = "bspline",
    domainImage=circ,
    numberOfFittingLevels = 6,
    meshSize = c(1,1) )
  mydisp = displacementFieldFromAntsrTransform(fit$transform)
  disp = smoothImage( mydisp * (0.5), 3.0 )
  txlist[[j]]=antsrTransformFromDisplacementField( disp )
  comptx = composeAntsrTransforms( txlist )
  newpts = applyAntsrTransformToPoint( comptx, cpts )
  print( paste(j,mean(abs(data.matrix(newpts)-spts)) ))
}
warped = applyAntsrTransformToImage(
        comptx,
        squar,
        circ,
        interpolation = "linear"
      )


# this is just to apply the warp to the grid
disktx='/tmp/temp.nii.gz'
finaldisp = composeTransformsToField( circ, txlist )
antsImageWrite( finaldisp, disktx)
warpedg = createWarpedGrid(
       circ,
       gridStep = 10,
       gridWidth = 2,
       gridDirections = c(TRUE, TRUE),
       fixedReferenceImage = circ,
       transform = disktx,
       foreground = 1,
       background = 0
     )

layout( matrix(1:4,nrow=1))
plot( circ, circ, doCropping=F, alpha=0.5 )
plot( squar, squar,  doCropping=F, alpha=0.5 )
plot( circ, warped, doCropping=F )
plot( warpedg , doCropping=F )
