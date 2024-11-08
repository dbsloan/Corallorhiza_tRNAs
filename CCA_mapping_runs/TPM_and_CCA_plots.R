library(tidyverse)
library(scales)

#extract all the control files files with unique mapping reads
filenames = list.files(path= ".", pattern=glob2rx("Cm_Control*CCA.unique.txt"), full.names = TRUE)

#initiate empty data frames
combined_mito_data = data.frame()
combined_plastid_data = data.frame()

#loop through each file
for (i in filenames){
  
  file_data = read.table(i, header = TRUE)
  
  #parse bio rep from file name (number followed by lowercase letter)
  rep = extracted_value <- str_extract(i, "\\d+[a-z]")

  #limit to organellar reads
  file_data = file_data %>% filter(str_detect(Ref_tRNA, "mitochondrial") | str_detect(Ref_tRNA, "plastid"))
  
  #sum all organlle mapping reads for the sake of later TPM calculations
  total_reads = sum(file_data$CCA_count) + sum(file_data$CC_count) + sum(file_data$Other_count) 

  #rename gene that had "native" in reference but should be cp.
  file_data = file_data %>% mutate(Ref_tRNA = ifelse(Ref_tRNA == "mitochondrial_native-Cma-AsnGTT-8", "mitochondrial_cp-Cma-AsnGTT-8", Ref_tRNA))
  file_data = file_data %>% mutate(Ref_tRNA = ifelse(Ref_tRNA == "mitochondrial_native-Cma-eMetCAT-9", "mitochondrial_cp-Cma-eMetCAT-9", Ref_tRNA))
  
  #split gene name into columns
  file_data = file_data %>% separate(Ref_tRNA, into = c("Genome", "Species", "Isodecoder", "ID"), sep = "-")

  #change Met isodecoder naming so that it sorts alphabetically. Label the fungus one as "Met(e)" even though there isn't an initiator/elongator distinction.
  file_data = file_data %>% mutate(Isodecoder = ifelse(Isodecoder == "iMetCAT", "Met(i)CAT", Isodecoder))
  file_data = file_data %>% mutate(Isodecoder = ifelse(Isodecoder == "eMetCAT", "Met(e)CAT", Isodecoder))
  file_data = file_data %>% mutate(Isodecoder = ifelse(Isodecoder == "MetCAT", "Met(e)CAT", Isodecoder))

  #calculate TPM, add biorep number and set minimu TPM to 1 instead of 0 for future log scale plotting
  file_data = file_data %>% mutate (TPM = 1e6 * (CCA_count + CC_count + Other_count) / total_reads)
  file_data = file_data %>% mutate (Biorep = rep)
  file_data = file_data %>% mutate(TPM = ifelse(TPM == 0, 1, TPM))
  
  #filter for mito genes
  file_data_mito = file_data %>% filter(str_detect(Genome, "mitochondrial"))
  
  #split genome label to separate origin info
  file_data_mito = file_data_mito %>% separate(Genome, into = c("Genome", "Origin"), sep = "_")
  
  #add file from each bio rep to larger dataframe
  combined_mito_data = rbind(combined_mito_data, file_data_mito)

  #filter for plasitd genes and add file from each bio rep to larger dataframe
  file_data_plastid = file_data %>% filter(str_detect(Genome, "plastid"))
  combined_plastid_data = rbind(combined_plastid_data, file_data_plastid)
  
}

#set order for levels to align with preferred colors in dark2 palette
combined_mito_data$Origin = factor(combined_mito_data$Origin, levels=c("cp", "native", "fungal", "bact"), labels=c("Plastid-derived", "Native mitochondrial", "Fungal-derived", "Bacterial-derived"))

#make mito TPM plot this combines the TPM values for the two different cp-like IleCAT genes
combined_mito_data %>%
  group_by(Isodecoder, Origin, Biorep) %>%
  summarise(Total_TPM = sum(TPM), .groups = 'drop') %>%
  ggplot(aes(x=Isodecoder, y=Total_TPM, color=Origin, group=Origin, shape=Origin)) +
    geom_point(alpha=0.5, size=1, position=position_dodge(width=0.5)) +
    scale_color_brewer(palette = "Dark2") +
    theme_bw() +
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1, size=6)) +
    theme(axis.text.y = element_text(size=6)) +
    theme(legend.text = element_text(size=6)) +
    theme(axis.title = element_text(size=7, face="bold")) +
    theme(legend.title = element_text(size=7, face="bold")) +
    theme(legend.position = "top") +
    xlab("Mitochondrial Isodecoder") + 
    ylab("Transcripts Per Million") +
    scale_y_log10(limits=c(1,100000), labels = label_comma())

ggsave ("plots/Mito_TPM.pdf", width = 3.25, height = 2.75)

#make plastid TPM plot
combined_plastid_data %>%
  ggplot(aes(x=Isodecoder, y=TPM)) +
  geom_point(alpha=0.5, stroke=0) +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1, size=6)) +
  theme(axis.text.y = element_text(size=6)) +
  theme(axis.title = element_text(size=7, face="bold")) +
  xlab("Plastid Isodecoder") + 
  ylab("Transcripts Per Million") +
  scale_y_log10(limits=c(1,1000000), labels = label_comma())

ggsave ("plots/Plastid_TPM.pdf", width = 5.25, height = 2.25)

#print (combined_mito_data)


filenames2 = list.files(path= ".", pattern="CCA.unique.txt", full.names = TRUE)

combined_CCA_data = data.frame()

for (i in filenames2){
  
  file_data = read.table(i, header = TRUE)
  rep = extracted_value <- str_extract(i, "\\d+[a-z]")
  exploded_filename <- strsplit(i, "_")[[1]]
  trt = exploded_filename[2]
  
  #limit to organellar reads
  file_data = file_data %>% filter(str_detect(Ref_tRNA, "mitochondrial") | str_detect(Ref_tRNA, "Bacillus"))
  
  #limit to genes with >= 30 reads
  file_data = file_data %>% filter(CCA_count + CC_count >= 30)
  
  #rename gene that had "native" in reference but should be cp and the spike-in control
  file_data = file_data %>% mutate(Ref_tRNA = ifelse(Ref_tRNA == "mitochondrial_native-Cma-AsnGTT-8", "mitochondrial_cp-Cma-AsnGTT-8", Ref_tRNA))
  file_data = file_data %>% mutate(Ref_tRNA = ifelse(Ref_tRNA == "mitochondrial_native-Cma-eMetCAT-9", "mitochondrial_cp-Cma-eMetCAT-9", Ref_tRNA))
  file_data = file_data %>% mutate(Ref_tRNA = ifelse(Ref_tRNA == "Bacillus_trnI_control", "Negative Control_Negative Control-Bacillus-Ile-26", Ref_tRNA))
  
  #split gene name into columns
  file_data = file_data %>% separate(Ref_tRNA, into = c("Genome", "Species", "Isodecoder", "ID"), sep = "-")
  
  #change Met isodecoder naming so that it sorts alphabetically. Label the fungus one as "Met(e)" even though there isn't an initiator/elongator distinction.
  file_data = file_data %>% mutate(Isodecoder = ifelse(Isodecoder == "iMetCAT", "Met(i)CAT", Isodecoder))
  file_data = file_data %>% mutate(Isodecoder = ifelse(Isodecoder == "eMetCAT", "Met(e)CAT", Isodecoder))
  file_data = file_data %>% mutate(Isodecoder = ifelse(Isodecoder == "MetCAT", "Met(e)CAT", Isodecoder))
  
  #calc CCA ratio add biorep and treatment
  file_data = file_data %>% mutate (CCA_Percentage = 100 * CCA_count / (CCA_count + CC_count))
  file_data = file_data %>% mutate (Biorep = rep)
  file_data = file_data %>% mutate (Treatment = trt)

  #split genome label to separate origin info
  file_data = file_data %>% separate(Genome, into = c("Genome", "Origin"), sep = "_")
  
  combined_CCA_data = rbind(combined_CCA_data, file_data)
  
}  

#set order for levels to align with preferred colors in dark2 palette
combined_CCA_data$Origin = factor(combined_CCA_data$Origin, levels=c("cp", "native", "fungal", "Negative Control"), labels=c("Plastid-derived", "Native mitochondrial", "Fungal-derived", "Synthetic Spike-in Control"))

combined_CCA_data %>%
  group_by(Isodecoder, Origin, ID, Treatment) %>%
  summarise(Mean_CCA_Percentage = mean(CCA_Percentage), .groups = 'drop') %>%
  ggplot(aes(x=Treatment, y=Mean_CCA_Percentage, color=Origin)) +
    stat_summary(aes(group = ID), geom = "line", fun = mean, alpha=0.15)+
    geom_point(alpha=0.15, size=1.5, stroke=0) +
    scale_color_brewer(palette = "Dark2") +
    theme_bw() +
    theme(panel.grid = element_blank()) +
    theme(axis.text.x = element_text(size=6)) +
    theme(axis.text.y = element_text(size=6)) +
    theme(legend.text = element_text(size=6)) +
    theme(axis.title = element_text(size=7, face="bold")) +
    theme(legend.title = element_text(size=7, face="bold")) +
    theme(legend.position = "top") +
    ylab("CCA Percentage") +
    ylim (c(0,100))
    
ggsave ("plots/Mito_CCA.pdf", width = 4.5, height = 2.75)

  