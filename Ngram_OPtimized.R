FREQUENCY_THRESHOLD = 2
library(data.table)
library(splitstackshape)
setwd("c://R/Coursera-SwiftKey/final/en_US")
load("ngram_table.Rdata")
ng <- cSplit_f(ngram_table, "ngrams", " ")
ngram_number <- ncol(ng) # Potentially used to abstract out the max n-gram number
names(ng) <- gsub("ngrams_", "n", names(ng))
ng_1 <- ng[,1, with=FALSE]
ng_2 <- ng[,1:2, with=FALSE]
ng_3 <- ng[,1:3, with=FALSE]
ng_4 <- ng[,1:4, with=FALSE]
ng_5 <- ng[,1:5, with=FALSE]
ng_6 <- ng
ng_1 <- ng_1[ n1 != 'BREAK_TAG' ]
ng_2 <- ng_2[ n1 != 'BREAK_TAG' & n2 != 'BREAK_TAG' ]
ng_3 <- ng_3[ n1 != 'BREAK_TAG' & n2 != 'BREAK_TAG' & n3 != 'BREAK_TAG' ]
ng_4 <- ng_4[ n1 != 'BREAK_TAG' & n2 != 'BREAK_TAG' & n3 != 'BREAK_TAG' & n4 != 'BREAK_TAG' ]
ng_5 <- ng_5[ n1 != 'BREAK_TAG' & n2 != 'BREAK_TAG' & n3 != 'BREAK_TAG' & n4 != 'BREAK_TAG' & n5 != 'BREAK_TAG' ]
ng_6 <- ng_6[ n1 != 'BREAK_TAG' & n2 != 'BREAK_TAG' & n3 != 'BREAK_TAG' & n4 != 'BREAK_TAG' & n5 != 'BREAK_TAG' & n6 != 'BREAK_TAG' ] 
ngram_1_freq <- ng_1[, .N ,by = list(n1)]
ngram_2_freq <- ng_2[, .N ,by = list(n1,n2)]
ngram_3_freq <- ng_3[, .N ,by = list(n1,n2,n3)]
ngram_4_freq <- ng_4[, .N ,by = list(n1,n2,n3,n4)]
ngram_5_freq <- ng_5[, .N ,by = list(n1,n2,n3,n4,n5)]
ngram_6_freq <- ng_6[, .N ,by = list(n1,n2,n3,n4,n5,n6)]
ng_1 <- ngram_1_freq[ N >= FREQUENCY_THRESHOLD ]
ng_2 <- ngram_2_freq[ N >= FREQUENCY_THRESHOLD ]
ng_3 <- ngram_3_freq[ N >= FREQUENCY_THRESHOLD ]
ng_4 <- ngram_4_freq[ N >= FREQUENCY_THRESHOLD ]
ng_5 <- ngram_5_freq[ N >= FREQUENCY_THRESHOLD ]
ng_6 <- ngram_6_freq[ N >= FREQUENCY_THRESHOLD ]
setkey(ng_1,n1)
ng_1$P <- ng_1$N / sum(ng_1$N)
setnames(ng_1, c("WORD", "N","P"))
ng_1 <- ng_1[order(-N)][1:100]

setkey(ng_1,WORD)
setkey(ng_2,n1,n2)
setkey(ng_3,n1,n2,n3)
setkey(ng_4,n1,n2,n3,n4)
setkey(ng_5,n1,n2,n3,n4,n5)
setkey(ng_6,n1,n2,n3,n4,n5,n6)
save(ng_1, ng_2, ng_3, ng_4, ng_5, ng_6, file="ngram_optimized.Rdata")