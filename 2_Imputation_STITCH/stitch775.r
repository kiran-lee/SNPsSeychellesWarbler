library('STITCH')
getwd()
STITCH(tempdir = tempdir(), chr="ENA|OU383775|OU383775.1_RagTag",  bamlist="bamlistrg.txt", posfile="ENA|OU383775.txt", sampleNames_file="bamlist.txt", outputdir= paste0(getwd(), "/"), K=4, nGen=25, nCores=28, expRate=1)
