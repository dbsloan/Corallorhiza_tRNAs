library(tidyverse)

misincorps = read.table("fungal_genes_modifications.long.txt", header=TRUE)

misincorps$MapStatus = factor(misincorps$MapStatus, levels = c("Deletion", "A_Mismatch", "C_Mismatch", "G_Mismatch", "T_Mismatch", "Reference"))
misincorps$Gene = factor(misincorps$Gene, levels = c("mitochondrial_fungal-Cma-GlnTTG-22", "mitochondrial_fungal-Cma-MetCAT-19"), labels = c("Fungal GlnTTG", "Fungal MetCAT"))

misincorps %>% 
  #filter(!(Gene == "mitochondrial_fungal-Cma-GlnTTG-22" & Position >= 72)) %>%
  #filter(!(Gene == "mitochondrial_fungal-Cma-MetCAT-19" & Position >= 74)) %>%
    ggplot(aes(x=Position, y=ReadCount, fill=MapStatus)) + 
    geom_col() + facet_wrap(~Gene, nrow=2) + 
    theme_bw() + 
    scale_fill_manual(values = c("black","chartreuse4", "steelblue", "goldenrod", "firebrick", "gray70")) + 
    ylab ("Read Count") + 
    xlim (c(0,80)) +
    theme(legend.key.size = unit(0.3, "cm"), strip.text = element_text(size=6, margin = margin(2,2,2,2)), axis.text = element_text(size=6), legend.title = element_blank(), legend.text=element_text(size=5.5), axis.title = element_text(size=8,face="bold"), panel.grid.major = element_blank(), panel.grid.minor = element_blank())
  
ggsave ("fungal_misincorps.pdf", width=3.75, height=2.4)
