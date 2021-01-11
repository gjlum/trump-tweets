# Group project

# Install packages if you have not done so yet

#install.packages("stringr")
#install.packages('tm')
#install.packages("Snowballc")
#install.packages("wordcloud")
#install.packages('ggplot2')
#install.packages("RColorBrewer")
#install.packages('cluster')
#install.packages('factoextra')
#install.packages('tidytext')
#install.packages('syuzhet')
#install.packages('dplyr')
#install.packages('lubridate')
#install.packages('reshape2')

#load libraries
library('tm')
library('SnowballC')
library('wordcloud')
library('ggplot2')
library(stringr)

# read dataset
trump_tweets <- read.csv("Donald-Trump_7375-Tweets-Excel.csv",head=TRUE, stringsAsFactors = FALSE)
head(trump_tweets)
str(trump_tweets)

# remove irrelevant variables
trump_tweets$Tweet_Id <- NULL # Removing the ID variable
trump_tweets$Tweet_Url <- NULL # Removing the URL variable
trump_tweets$Media_Type <- NULL
trump_tweets$X <- NULL
trump_tweets$X.1 <- NULL



# creating a corpus for text processing
corpus <- Corpus(VectorSource(trump_tweets$Tweet_Text))
corpus
# To see the text and examine the corpus
for (i in 1:6) print (corpus[[i]]$content)

# Corpus transformation
removeSpecialChar <- function(x) str_replace_all(x, "[^[:alnum:]]", " ")
removeURL <- removeURL <- function(x) gsub("(f|ht)tp(s?)://\\S+", "", x, perl = T)    # Assign URL variable
corpus <- tm_map(corpus, content_transformer(removeURL))        # Remove URLs
corpus <- tm_map(corpus, content_transformer(tolower))		# Lowercase texts
corpus <- tm_map(corpus, content_transformer(removePunctuation))
corpus <- tm_map(corpus, content_transformer(removeSpecialChar))
corpus <- tm_map(corpus, content_transformer(removeNumbers))	# Remove numbers
corpus <- tm_map(corpus, content_transformer(removeWords), stopwords("english")) # Remove stopwords
corpus <- tm_map(corpus, removeWords, c("trump","realdonaldtrump","amp")) # Refine data by repetitive Twitter account name 'realdonaldtrump'
corpus <- tm_map(corpus, stripWhitespace) 			# Remove extra whitespace

set.seed(1234)

### Bag of Words analysis
# create a document term matrix (dtm)
dtm <- DocumentTermMatrix(corpus)
dtm
m <- as.matrix(dtm)  # convert dtm to a matrix
dim(m) #print the dimensions of dtm_matrix
m[1:10, 1:10]

# Make Term Document Matrix
tdm <- TermDocumentMatrix(corpus)
m2 <- as.matrix(tdm)
dim(m2)
m2[1:10, 1:20]

# Find most frequent terms
frequency <- colSums(m)
frequency <- sort(frequency, decreasing=TRUE)
head(frequency)

# colors 
library(RColorBrewer)
pal <- brewer.pal(8, "Accent")[-(1:4)]

# Create word cloud
words <- names(frequency)

#wordcloud(words = words[1:100], freq = frequency[1:100], min.freq = 3, random.order = F, colors = pal)
wordcloud(words[1:100], frequency[1:100], random.order = F, colors = pal )

# Create box plot
w <- rowSums(m2)
w <- subset(w, w>=500)
barplot(w, las = 2)

# Remove sparse or low frequent terms
dtm_rm_sparse <- removeSparseTerms(dtm, 0.98)

# Print out scaled matrix
dtm_rm_sparse

#convert to matrix
m3 <- as.matrix(dtm_rm_sparse)
dim(m3) # print dimension
m3[1:10, 1:10] # view portion of the matrix

# k means clustering
library(cluster)
library(factoextra)


# find optimal k using elbow method
fviz_nbclust(m3, kmeans, method = "wss")


# extracting results for optimal k = 3
kmeans_result <- kmeans(m3, 3, nstart = 25)

# accessing kmeans_result components
kmeans_result$cluster
kmeans_result$size
kmeans_result$centers
kmeans_result$iter
kmeans_result$tot.withinss
kmeans_result$betweenss

# visualize clusters

fviz_cluster(kmeans_result, data = m3)

# checking the top 5 words in each cluster
for (i in 1:3) {
  cat(paste("cluster", i, ":", sep = ""))
  s <- sort(kmeans_result$centers[i,], decreasing = T)
  cat(names(s)[1:5], "\n")
}

# Sentiment Analysis
library(tidytext)
library(syuzhet)

# removing special character from the orginal dataset
tweets <- iconv(trump_tweets$Tweet_Text)
s <- get_nrc_sentiment(tweets) #get sentiment
head(s) # take a look at the head of the scores

# add sentiment to the tweets data frame
trump_tweets <- cbind(trump_tweets, s)
total_sentiment <- data.frame(colSums(trump_tweets[, c(8:17)]))
names(total_sentiment) <- "count"
total_sentiment <- cbind("sentiment" = rownames(total_sentiment), total_sentiment)

# visualize the sentiments
library(dplyr)
library(lubridate)
library(reshape2)

ggplot(aes(x= sentiment, y = count, fill = sentiment), data = total_sentiment) + geom_bar(stat = "identity") + ggtitle("Sentiment Score for Trump's Tweets") + theme(legend.position = "none")



# End Script