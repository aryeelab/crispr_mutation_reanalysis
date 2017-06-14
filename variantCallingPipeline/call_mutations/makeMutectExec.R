
d <- data.frame(
  normal = c("SRR5450998", "SRR5450998", "SRR5450997", "SRR5450997", "SRR5450996", "SRR5450996"),
  tumor  = c("SRR5450996", "SRR5450997", "SRR5450996", "SRR5450998", "SRR5450997", "SRR5450998"),
  name   = c(   "n98_t96",    "n98_t97",    "n97_t96",    "n97_t98",    "n96_t97",    "n96_t98")
)

chrs <- paste0("chr", c(as.character(17:19)))


lapply(1:6, function(i){
  lapply(chrs, function(chr){
    write(c(paste0("bsub -q big sh mutectRunner.sh ", d[i,1], " ", d[i,2], " ",  d[i,3], " ", chr), "sleep 1"), file = "mutectExecLate.txt", append = TRUE, sep = "\n")
  })
})



