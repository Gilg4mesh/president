library(xml2)
library(httr)
library(rvest)
options(stringsAsFactors = F)

getNextUrl <- function(url) {
  nextPage <- read_html(url) %>% 
    html_node(".noprint~ td+ .noprint a") %>%
    html_attr("href")
  
  paste0("https://zh.wikisource.org", nextPage)
}


url <- "https://zh.wikisource.org/wiki/中華民國第一任總統就職演說" # https://zh.wikisource.orgNA

# doc   <- read_html(url) # Get and parse the url
# 
# css.president <- "#mw-content-text br+ a"
# node.president <- html_nodes(doc, css.president); node.president
# class(node.president)
# president <- html_attr(node.president, "title"); president
# 
# css.speech <- "#mw-content-text .mw-parser-output > p"
# node.speech <- html_nodes(doc, css.speech)
# class(node.speech)
# speech <- paste(html_text(node.speech, "p"), collapse = ""); speech

session <- 1
final <- data.frame()
while(url != "https://zh.wikisource.orgNA") {
  doc   <- read_html(url)
  
  css.president <- "#mw-content-text br+ a"
  node.president <- html_nodes(doc, css.president); node.president
  class(node.president)
  president <- html_attr(node.president, "title"); president
  president <- gsub("Author:", "", president)
  president <- gsub("（页面不存在）", "", president)
  
  css.speech <- "#mw-content-text .mw-parser-output > p"
  node.speech <- html_nodes(doc, css.speech)
  class(node.speech)
  speech <- paste(html_text(node.speech, "p"), collapse = ""); speech
  
  
  temp <- data.frame(session=session, president=president, speech=speech)
  final <- rbind(final, temp)
  
  url <- getNextUrl(url)
  print(paste("page:", session, "done"))
  session <- session + 1
  Sys.sleep(1)
}

rm(temp, css.president, css.speech, doc, node.president, node.speech, president, session, speech, url)

write.csv( final, file="final.csv" )
