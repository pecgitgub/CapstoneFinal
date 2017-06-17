## Load CRAN modules 
library(downloader)
library(plyr);
library(dplyr)
library(knitr)
library(tm)
library(stringi)
library(RWeka)
library(ggplot2)
library(slam)
setwd("c://R/Coursera-SwiftKey/final/en_US")
options(mc.cores=1)


# Lets make a file connection of the twitter data set
con <- file("./en_US.twitter.txt", "r") 
#lineTwitter<-readLines(con,encoding = "UTF-8", skipNul = TRUE)
lineTwitter<-readLines(con, skipNul = TRUE)
# Close the connection handle when you are done
close(con)
# Lets make a file connection of the blog data set
con <- file("./en_US.blogs.txt", "r") 
#lineBlogs<-readLines(con,encoding = "UTF-8", skipNul = TRUE)
lineBlogs<-readLines(con, skipNul = TRUE)
# Close the connection handle when you are done
close(con)
# Lets make a file connection of the news data set
con <- file("./en_US.news.txt", "r") 
#lineNews<-readLines(con,encoding = "UTF-8", skipNul = TRUE)
lineNews<-readLines(con, skipNul = TRUE)
# Close the connection handle when you are done
close(con)
# Get file sizes
lineBlogs.size <- file.info("./en_US.blogs.txt")$size / 1024 ^ 2
lineNews.size <- file.info("./en_US.news.txt")$size / 1024 ^ 2
lineTwitter.size <- file.info("./en_US.twitter.txt")$size / 1024 ^ 2

# Get words in files
lineBlogs.words <- stri_count_words(lineBlogs)
lineNews.words <- stri_count_words(lineNews)
lineTwitter.words <- stri_count_words(lineTwitter)

# Summary of the data sets
data.frame(source = c("blogs", "news", "twitter"),
           file.size.MB = c(lineBlogs.size, lineNews.size, lineTwitter.size),
           num.lines = c(length(lineBlogs), length(lineNews), length(lineTwitter)),
           num.words = c(sum(lineBlogs.words), sum(lineNews.words), sum(lineTwitter.words)),
           mean.num.words = c(mean(lineBlogs.words), mean(lineNews.words), mean(lineTwitter.words)))
## Cleaning The Data
# Sample the data
set.seed(5000)
data.sample <- c(sample(lineBlogs, length(lineBlogs) * 0.02),
                 sample(lineNews, length(lineNews) * 0.02),
                 sample(lineTwitter, length(lineTwitter) * 0.02))

# Create corpus and clean the data
corpus <- VCorpus(VectorSource(data.sample))
toSpace <- content_transformer(function(x, pattern) gsub(pattern, " ", x))
corpus <- tm_map(corpus, toSpace, "(f|ht)tp(s?)://(.*)[.][a-z]+")
corpus <- tm_map(corpus, toSpace, "@[^\\s]+")
corpus <- tm_map(corpus, tolower)
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, stripWhitespace)
corpus <- tm_map(corpus, PlainTextDocument)
unicorpus <- tm_map(corpus, removeWords, stopwords("en"))


##Exploratory Analysis
# we'll get the frequencies of the word
getFreq <- function(tdm) {
  freq <- sort(rowSums(as.matrix(tdm)), decreasing = TRUE)
  return(data.frame(word = names(freq), freq = freq))
}

# Prepare n-gram frequencies
getFreq <- function(tdm) {
  freq <- sort(rowSums(as.matrix(rollup(tdm, 2, FUN = sum)), na.rm = T), decreasing = TRUE)
  return(data.frame(word = names(freq), freq = freq))
}
bigram <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))
trigram <- function(x) NGramTokenizer(x, Weka_control(min = 3, max = 3))
quadgram <- function(x) NGramTokenizer(x, Weka_control(min = 4, max = 4))
pentagram <- function(x) NGramTokenizer(x, Weka_control(min = 5, max = 5))
hexagram <- function(x) NGramTokenizer(x, Weka_control(min = 6, max = 6))

# Get frequencies of most common n-grams in data sample
freq1 <- getFreq(removeSparseTerms(TermDocumentMatrix(unicorpus), 0.999))
save(freq1, file="nfreq.f1.RData")
freq2 <- getFreq(TermDocumentMatrix(unicorpus, control = list(tokenize = bigram, bounds = list(global = c(5, Inf)))))
save(freq2, file="nfreq.f2.RData")
freq3 <- getFreq(TermDocumentMatrix(corpus, control = list(tokenize = trigram, bounds = list(global = c(3, Inf)))))
save(freq3, file="nfreq.f3.RData")
freq4 <- getFreq(TermDocumentMatrix(corpus, control = list(tokenize = quadgram, bounds = list(global = c(2, Inf)))))
save(freq4, file="nfreq.f4.RData")
freq5 <- getFreq(TermDocumentMatrix(corpus, control = list(tokenize = pentagram, bounds = list(global = c(2, Inf)))))
save(freq5, file="nfreq.f5.RData")
freq6 <- getFreq(TermDocumentMatrix(corpus, control = list(tokenize = hexagram, bounds = list(global = c(2, Inf)))))
save(freq6, file="nfreq.f6.RData")
nf <- list("f1" = freq1, "f2" = freq2, "f3" = freq3, "f4" = freq4, "f5" = freq5, "f6" = freq6)
save(nf, file="nfreq.v5.RData")



