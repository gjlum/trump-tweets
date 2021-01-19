  <h3 align="center">Donald Trump Tweets</h3>
  <p align="center">
    Conducting Sentiment Analysis Using R
  </p>
</p>

<!-- TABLE OF CONTENTS -->
<details open="open">
  <summary><h2 style="display: inline-block">Table of Contents</h2></summary>
  <ol>
    <li><a href="#project-summary">Project Summary</a></li>
    <li><a href="#data-cleaning">Data Cleaning</a></li>
    <li><a href="#exploratory-analysis">Expoloratory Analysis</a></li>
    <li><a href="#cluster-analysis">Cluster Analysis</a></li>
    <li><a href="#visualize-sentiment">Visualize Sentiment</a></li>
    <li><a href="#conclusion">Conclusion</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgements">Acknowledgements</a></li>
  </ol>
</details>



<!-- PROJECT SUMMARY -->
## Project Summary

The goal of this analysis is to take a look at Donald Trump's twitter account and the general themes his messages convey. NLP and sentiment analysis algorimthms will allow us to classify key words used in his tweets in order to provide an aggregated view of his sentiments. Since tweets are very noisy, many steps will have to be taken to ensure the accuracy of our analysis of a dataset that has high sparseness and is highly dimensional. In order to use our K-means algorithm we will be using TF-IDF and PCA so that we can try to reduce the impact of the noise. This project was built using [R](https://cran.r-project.org/) and [RStudio](https://rstudio.com/) along with many different packages outlined in `Trump_Tweets_2020.R`. 

<!-- DATA CLEANING -->
## Data Cleaning

To perform any text analysis, it is essential that the text is transformed and normalized to produce actionable and insightful information.  Tweets are more difficult because they are highly prone to human error and can be littered with typos, additional characters/symbols, punctuation, slang, and links that can make it difficult to normalize the dataset. We can immediately remove the irrelevant variables from our dataset like Tweet_ID and Tweet_URL as they do not contribute to the analysis. Once we have removed these we can begin building our corpus. This corpus will allow us to remove additional unnecessary information such as any URL's, punctuation, special characters, and stopwords. After removing these we will finally be transforming all the remaining words to lowercase, removing extra spaces, and removing all numbers. The last, but very beneficial step, will be to remove the words trump and realdonaldtrump from the corpus as they are the President's last name and Twitter username and will appear in most or all tweets.

<!-- EXPLORATORY ANALYSIS -->
## Exploratory Analysis
