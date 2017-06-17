SAMPLE_SIZE <- 0.02
library(stylo)
library(data.table)
set.seed(900)
#Load Data
setwd("c://R/Coursera-SwiftKey/final/en_US")
tweet.con <- file("en_US.twitter.txt", open="rb")
tweet.vector <- readLines(tweet.con, skipNul = TRUE)
tweet.count <- length(tweet.vector)
tweet.subset <- sample(tweet.vector, size=tweet.count * SAMPLE_SIZE, replace = FALSE)
close(tweet.con)
rm(tweet.vector, tweet.con, tweet.count)

blog.con <- file("en_US.blogs.txt", open="rb")
blog.vector <- readLines(blog.con)
blog.count <- length(blog.vector)
blog.subset <- sample(blog.vector, size=blog.count * SAMPLE_SIZE, replace = FALSE)
close(blog.con)
rm(blog.vector, blog.con, blog.count)

news.con <- file("en_US.news.txt", open="rb")
news.vector <- readLines(news.con)
news.count <- length(news.vector)
news.subset <- sample(news.vector, size=news.count * SAMPLE_SIZE, replace = FALSE)
close(news.con)
rm(news.vector, news.con, news.count)
word_vector <- c(tweet.subset, blog.subset, news.subset)
rm(tweet.subset, blog.subset, news.subset)
word_vector <- paste("startofline", word_vector, "endofline")

ordered_words <- txt.to.words.ext(word_vector, language="English.contr", preserve.case = FALSE)

rm(word_vector)

ordered_words <- gsub("startofline", "BREAK_TAG", ordered_words)
ordered_words <- gsub("endofline", "BREAK_TAG", ordered_words)

# txt.to.words.ext outputs "^" instead of "'"
ordered_words <- gsub("\\^", "'", ordered_words)

ngrams <- make.ngrams(ordered_words, ngram.size = 6)
ngram_table <- data.table(ngrams)
save(ngram_table, file="ngram_table.Rdata")
