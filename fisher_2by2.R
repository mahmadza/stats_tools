#!/usr/local/bin/Rscript --vanilla

#paste0 function
paste0 <- function( ..., sep="" ) paste( ..., sep = sep )

#possible alternative testing:
poss_alt=c("two.sided","less","greater")

#default arguments
x=1 #x column
y=2 #y column
test_alt<-"two.sided"

#retrieve arguments
args<-commandArgs(TRUE)

#help
help <- function(){
  cat("\nfisher_2by2.R : Calculate Fisher's exact test p-value for two columns of a tab-delimited input\n")
  cat("Usage: fisher_2x2.R -i -\n")
  cat("-i : Input file or stdin (-)\n")
  cat("-x : Which column is on the x axis (default=1)\n")
  cat("-y : Which column is on the y axis (default=2)\n")
  cat(paste0("-m : alternative hypothesis (possible: ",poss_alt,")\n\n"))
  cat("\n")
  q()
}

#save values of each argument
if(length(args)==0 || !is.na(charmatch("-help",args))){
  help()
  } else {
    for(ii in 1:length(args)){
      if(grepl("^-",args[ii]) && args[ii] != "-"){
        if(ii+1<=length(args) && (!grepl("^-",args[ii+1]) || args[ii+1]=="-")){
          assign(gsub("-","",args[ii]),args[ii+1])
          } else { assign(gsub("-","",args[ii]),1) }
        }
    }
 }

#load data into a table
if(exists("i")){
  if(i=="-"){
    #load values from stdin
    d=read.table(pipe('cat /dev/stdin'))
  } else if (file.exists(i)){
    #load values from file
    d=as.matrix(read.table(i,fill=T))
  } else {
    cat("Input file does not exist\n")
    q()
    }
  } else {
    cat("No input specified\n")
    q()
 }


#assign alternative hypothesis, if specificied
if (exists("m")){
   test_alt=m
   }

#calculate Fisher's exact test p-value
p_val=signif(fisher.test(d,alternative=test_alt)$p.value)

#print results to stdout
cat(p_val,"\n")

