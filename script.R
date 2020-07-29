# Load
library("tm")
library("SnowballC")
library("wordcloud")
library("RColorBrewer")

text <- readLines(file.choose())

###example larger text file
filePath <- "http://www.sthda.com/sthda/RDoc/example-files/martin-luther-king-i-have-a-dream-speech.txt"
text <- readLines(filePath)
###

#Create Corpus
docs <- Corpus(VectorSource(text))

toSpace <- content_transformer(function (x , pattern ) gsub(pattern, " ", x))
docs <- tm_map(docs, toSpace, "/")
docs <- tm_map(docs, toSpace, "@")
docs <- tm_map(docs, toSpace, "\\|")

# Convert the text to lower case
docs <- tm_map(docs, content_transformer(tolower))
# Remove numbers
docs <- tm_map(docs, removeNumbers)
# Remove common stopwords
docs <- tm_map(docs, removeWords, stopwords("english"))
# Remove punctuation
docs <- tm_map(docs, removePunctuation)
# Eliminate extra white spaces
docs <- tm_map(docs, stripWhitespace)
# Code to remove defined stop words
#docs <- tm_map(docs, removeWords, c("", ""))

#Create DTM

dtm <- TermDocumentMatrix(docs)
m <- as.matrix(dtm)
v <- sort(rowSums(m),decreasing=TRUE)
d <- data.frame(word = names(v),freq=v)

#Simple wordcloud
set.seed(1)
wordcloud(words = d$word, freq = d$freq, min.freq = 1,
          max.words=200, random.order=FALSE, rot.per=0, scale = c(2,0.5),
          colors=brewer.pal(8, "Dark2"))
