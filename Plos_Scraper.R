library("rplos")
library("stringr")


##Read and def last updated date
Last_Updated_Date = toString(readLines("R_Last_Update.txt"))

##def current date
Current_Date = toString(Sys.Date())

##Create pub date search variable
PD_TimeFrame = paste('publication_date:[', Last_Updated_Date, 'T00:00:00Z TO ', Current_Date,'T00:00:00Z]', sep = "")

#Search for Number papers that have been published since last update
MetaResults <- searchplos(q="*:*", fl=c('id', 'title'), fq=list('doc_type:full',PD_TimeFrame), sort='publication_date desc', start=0, limit=1)
MetaList = MetaResults[1]
Meta = unlist(MetaList)
NumFiles = Meta[1] #Total Number of Papers found

#IF papers found -> Scrape papers that have been published since last update
if(NumFiles > 0){
  MetaResults <- searchplos(q="*:*", fl=c('id', 'title'), fq=list('doc_type:full',PD_TimeFrame), sort='publication_date desc', start=0, limit=NumFiles)
  ResultsList <- MetaResults[2]
  Results <- unlist(ResultsList)
  
  #Write Full Text to .txt file for each paper in results
  for(i in 1:NumFiles){
    #Get Paper Text
    FullText <- plos_fulltext(doi=Results[i])
    
    #Get and Format Title of Paper
    Title = str_replace_all(Results[i+NumFiles], "[^[:alnum:]]", " ")
    Title = substr(Title, start=1, stop=50) 
    FileTitle = paste('papers/',Title, '.txt', sep="")
    
    #Create txt file
    write(unlist(FullText), file = FileTitle)
  }
}

##Save last updated date
write(Current_Date, file = "R_Last_Update.txt")
