#!/usr/local/bin/Rscript  --vanilla

## Default arguments
x=1 # x column
y=2 # y column

## Retrieve arguments
args=commandArgs(TRUE)

## Help
help <- function(){
    cat("\nstudent.R : Calculate the student's t-test p-value for two columns of a tab-delimited input\n")
    cat("Usage: student.R -i -\n")
    cat("-i : Input file or stdin (-)\n")
    cat("-x : Which column is on the x axis (default=1)\n")
    cat("-y : Which column is on the y axis (default=2)\n")
    cat("\n")
    q()
}

## Save values of each argument
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

## Load data into a table
if(exists("i")){
    if(i=="-"){
        d=read.delim("/dev/stdin",header=F)
    } else if (file.exists(i)){
        d=read.delim(i,header=F)
    } else { cat("Input file does not exist\n"); q() }
} else { cat("No input specified\n"); q() }

## Calculate student's t-test p-value
student=signif(t.test(d[,as.numeric(x)],d[,as.numeric(y)],alternative=c("greater"),paired=TRUE)$p.value)
cat(student,"\n")
##default:one-sided x>y, unequal variance
