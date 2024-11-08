library (tidyverse)

setwd("/Users/sloan/Documents/ColoradoState/projects/tRNAs/MSR-seq/Corallorhiza/Sequencing/20240808_Corallorhizae_ribodepletion_RNAseq/analysis/20240914/coverage_analysis/20240922/depth_analysis")

filenames <- list.files(path= '.', pattern=c('SW.txt'), full.names = TRUE)


for (file in filenames){

  cov_data = read.table(file, header=TRUE)
  length = max(cov_data$Position)

  max_depth = max(cov_data$Depth)
  
  cov_data$Strand = factor(cov_data$Strand, levels = c("RF", "FR"))
  
  cov_data %>% 
    mutate(Depth = if_else(Strand == "FR", -Depth, Depth)) %>%
    ggplot (aes(x=Position, y=Depth, fill=Strand)) + 
    geom_bar(stat="identity") +
    theme_classic() +
    theme(legend.position = "none") +
    scale_fill_manual(values=c("black", "gray80")) +
    ylim(-max_depth, max_depth) +
    xlim (0 - 0.01*length , 1.01 * length ) +
    theme(axis.title = element_text(size=8, face="bold"), axis.text = element_text(size=7))
  
    ggsave(paste0(file, ".pdf"), width = 6.7, height = 4)

}

