#!/usr/local/bin/Rscript --vanilla


#paste0 function
paste0 <- function( ..., sep="" ) paste( ..., sep = sep )

#possible methods are:
#Pearson, Spearman, or Kendall correlation
#poss_method=c("pearson","spearman","kendall")

#default argument
test_method<-"spearman"

#retrieve arguments
args<-commandArgs(TRUE)

#help
help <- function(){
    cat("\nCorr.R : Calculate correlation of a tab-delimited input using Pearson, Spearman or Kendall method\n")
    cat("\nUsage: Corr.R -i -\n")
    cat("-i : input file or stdin (-)\n")
    cat(paste0("-m : method (default: ",test_method,")\n\n"))
    cat("CAUTION : Kendall can be VERY slow for really large dataset (>1,000)")
    cat("\n\n")
    q()
}

#save values of arguments
if(length(args)==0 || !is.na(charmatch("-help",args))){
    help()
} else {
    for(ii in 1:length(args)){
	if(grepl("^-",args[ii]) && args[ii] != "-"){
	    if(ii+1<=length(args) && (!grepl("^-",args[ii+1]) || args[ii+1]=="-")){
	        assign(gsub("-","",args[ii]),args[ii+1])
	    } else { assign(gsub("-","",args[ii]),1) }
	}
}}

#assign test method
test_method=m

#load data into table
if(exists("i")){
    if(i=="-"){
        d=as.matrix(read.table(pipe('cat /dev/stdin'))) # default is list so convert to matrix with as.matrix()
    } else if (file.exists(i)){
        d=as.matrix(read.table(i))
    } else { cat("Input file does not exist\n"); q() }
} else { cat("No input specified\n"); q() }


#calculate correlation
result=vector()
result=cor(d[,'V1'],d[,'V2'],method=test_method)

#return result
cat(format(result),"\n")
