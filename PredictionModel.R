library(data.table)
library(stylo)

# Load the Source Data
load("ngram_optimized.Rdata")

build_predict_table <- function(text) {
  COLUMN_NAMES <- c("WORD", "N","P")
  
  #This had better output 5 words
  t <- process_input_text(text)
  
  n_words <- length(t)
  
  # Default data.tables. Needed for cases when no matches are found and to aggregate all predictions
  Default.Table <- data.table(WORD=NA, N=NA, P=NA)
  predict_6 <- Default.Table
  predict_5 <- Default.Table
  predict_4 <- Default.Table
  predict_3 <- Default.Table
  predict_2 <- Default.Table
  
  # Assign Probabilities
  if (n_words >= 5) {
    predict_6 <- ng_6[J(t[n_words-4],t[n_words-3],t[n_words-2],t[n_words-1],t[n_words])][order(-N)][,6:7, with=FALSE]
    predict_6$P <- predict_6$N / sum(predict_6$N)
    names(predict_6) <- COLUMN_NAMES
  }
  if (n_words >= 4) {
    predict_5 <- ng_5[J(t[n_words-3],t[n_words-2],t[n_words-1],t[n_words])][order(-N)][,5:6, with=FALSE]
    predict_5$P <- predict_5$N / sum(predict_5$N)
    names(predict_5) <- COLUMN_NAMES
  }
  if (n_words >= 3) {
    predict_4 <- ng_4[J(t[n_words-2],t[n_words-1],t[n_words])][order(-N)][,4:5, with=FALSE]
    predict_4$P <- predict_4$N / sum(predict_4$N)
    names(predict_4) <- COLUMN_NAMES
  }
  if (n_words >= 2) {
    predict_3 <- ng_3[J(t[n_words-1],t[n_words])][order(-N)][,3:4, with=FALSE]
    predict_3$P <- predict_3$N / sum(predict_3$N)
    names(predict_3) <- COLUMN_NAMES
  }
  if (n_words >= 1) {
    predict_2 <- ng_2[J(t[n_words])][order(-N)][,2:3, with=FALSE]
    predict_2$P <- predict_2$N / sum(predict_2$N)
    names(predict_2) <- COLUMN_NAMES
  }
  
  # Combine Predictions
  predict_all <- rbind(predict_6, predict_5, predict_4, predict_3, predict_2, ng_1, fill=TRUE)[order(-P)][,c(1,3), with=FALSE]
  predict <- predict_all[,lapply(.SD,max),by="WORD"]
  
  # If nothing was predicted just return the top 100 single words, ordered by probability
  if (is.na( predict[1]$WORD )) {
    predict <- ng_1[order(-P)]
  }
  
  # We only want valid predictions
  predict <- predict[complete.cases(predict),]
  # return data.table with best matches
  return(predict)
}

process_input_text <- function(input_text) {
  # process input text in the same way that we processed our training data using stylo
  text_split <- txt.to.words.ext(input_text, language="English.contr", preserve.case = FALSE)
  text_split <- gsub("\\^", "'", text_split)
  # If the number of words is > 5, only use the last 5 words.
  n_words <- length(text_split)
  if (n_words > 5) {
    return(text_split[(n_words-4):n_words])
  } else{ return(text_split) }
}