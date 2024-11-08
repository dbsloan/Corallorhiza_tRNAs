library(tidyverse)

annotation_file_df=read.csv("annotation.csv")

contigs = c(2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,28,35,39,46)

height = 0.05
fungal_color = "goldenrod"
tRNA_color = "black"
other_gene_color = "darkblue"
for (node in contigs){

  pdf_name = paste0("contig", node, ".pdf")
  pdf(pdf_name)
  
  annotation = annotation_file_df %>% filter(ContigNum == node)
  length=annotation$Length[1]

  plot.new()
  
  for (i in 1:dim(annotation)[1]){
    
    if(annotation$Gene[i] == "Fungal HGT"){
      polygon(c(annotation$Start[i]/length, annotation$End[i]/length, annotation$End[i]/length, annotation$Start[i]/length), c(0.5+height/3, 0.5+height/3, 0.5-height/3, 0.5-height/3), col=fungal_color, border=NA)  
      text ((annotation$Start[i] + annotation$End[i]) / (2*length), 0.5 + 2*height, "Fungal HGT", adj = 0.5, cex = 0.5, col=fungal_color, font=2)
}else if(substr(annotation$Gene[i],1,3) == "trn"){
      if(annotation$End[i] > annotation$Start[i]){
        polygon(c(annotation$Start[i]/length, annotation$End[i]/length, annotation$End[i]/length, annotation$Start[i]/length), c(0.5+height, 0.5+height, 0.5, 0.5), col=tRNA_color, border=NA)  
        text ((annotation$Start[i] + annotation$End[i]) / (2*length), 0.5 + 1.25*height, annotation$Gene[i], adj = 0.5, cex = 0.5, col=tRNA_color)
      }else{
        polygon(c(annotation$Start[i]/length, annotation$End[i]/length, annotation$End[i]/length, annotation$Start[i]/length), c(0.5-height, 0.5-height, 0.5, 0.5), col=tRNA_color, border=NA)  
        text ((annotation$Start[i] + annotation$End[i]) / (2*length), 0.5 - 1.25*height, annotation$Gene[i], adj = 0.5, cex = 0.5, col=tRNA_color)
      }
    }else{
      if(annotation$End[i] > annotation$Start[i]){
        polygon(c(annotation$Start[i]/length, annotation$End[i]/length, annotation$End[i]/length, annotation$Start[i]/length), c(0.5+height, 0.5+height, 0.5, 0.5), col=other_gene_color, border=NA)  
        text ((annotation$Start[i] + annotation$End[i]) / (2*length), 0.5 + 1.25*height, annotation$Gene[i], adj = 0.5, cex = 0.5, col=other_gene_color)
      }else{
        polygon(c(annotation$Start[i]/length, annotation$End[i]/length, annotation$End[i]/length, annotation$Start[i]/length), c(0.5-height, 0.5-height, 0.5, 0.5), col=other_gene_color, border=NA)  
        text ((annotation$Start[i] + annotation$End[i]) / (2*length), 0.5 - 1.25*height, annotation$Gene[i], adj = 0.5, cex = 0.5, col=other_gene_color)
      }
    }
  }
  
  segments(0,0.5,1,0.5)
  
  dev.off()

}