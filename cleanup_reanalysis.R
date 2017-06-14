#

ss <- c("n96_t97", "n96_t98", "n97_t96", "n97_t98", "n98_t96", "n98_t97")
sapply(ss, function(s){
  chrs <- c(as.character(1:19), "X")
  ldf <- lapply(chrs, function(chr){
    snpdf <- data.frame(data.table::fread(paste0("zcat < ", s, "/", s, "_chr", as.character(chr), ".gz")))
    snpdf[snpdf$judgement == "KEEP",]
  })
  df <- plyr::ldply(ldf, data.frame)
  write.table(df, quote = FALSE, sep = "\t", row.names = FALSE, col.names = TRUE, 
              file = paste0("../crispr_reanalysis/SNV_reanalysis/new_variant_calls_raw/mutect_out/mutect_",
                            s, "/", s, "mutect.res.tsv"))
  s
})
