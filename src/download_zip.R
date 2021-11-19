# author: Jennifer Hoang
# date: 2021-11-18

"Downloads a zipped folder from a url and saves the unzipped 
folder to a specified file path

Usage: download_zip.R --url=<url> --file_path=<file_path>
  
Options:
--url=<url>                URL of zipped folder (quoted)
--file_path=<file_path>    File path (quoted)
" -> doc

library(docopt)

opt <- docopt(doc)

main <- function(opt){
  temp <- tempfile()
  download.file(opt$url, temp)
  unzip(temp, exdir = opt$file_path)
  unlink(temp)
}

main(opt)