# script for compiling the vignette

# this provides the online htm version of the book 
#    with each chapter in a different tab
#    located in ~/docs/index.html
#    click index.html and "View in Web Browser" 
bookdown::render_book("index.Rmd", "bookdown::gitbook")


bookdown::render_book("index.Rmd", "bookdown::pdf_book")
