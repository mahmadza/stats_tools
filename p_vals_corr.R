#!/usr/local/bin/Rscript --vanilla

#paste0 function
paste0=function( ..., sep="" ) paste( ..., sep = sep )

#possible multiple-testing methods:
poss_methods=c("holm", "hochberg", "hommel","bonferroni","BH","BY","fdr","none")
#Default
corr_method="bonferroni"

#Retrieve arguments
args=commandArgs(TRUE)

#help
help <- function(){
    cat("\np_val_corr.R : Calculate corrected P-values\n")
    cat("Usage: p_val_corr.R -i -\n")
    cat("-i : Input file or stdin (-)\n")
    cat(paste0("-m :correction methods (possible: ",as.character(poss_methods),")\n\n"))
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
  #if load from stdin
  if(i=="-"){
    d=read.table(pipe('cat /dev/stdin'))$V1
    } else if (file.exists(i)){
      d=as.matrix(read.table(i,fill=T))
      #if load from file
      } else 
        cat("Input file does not exist\n")
        q()
        }
     } else {
      cat("No input specified\n")
      q()
     }

#check if specify non-default multiple-testing method
#if yes, use that one instead of the default
if (exists("m")){
   corr_method=m
   }

#calculate the corrected adjusted p-values
#use length of the data set as n
p_adjusted=p.adjust(d,method=corr_method,n=length(d))

#print results to stdout
cat(p_adjusted,sep="\n")
