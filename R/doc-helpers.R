arg_choices <- function(name, choices){
  paste0("@param ", name, " one of the following values: ", paste(shQuote(choices), collapse = ", "), ".")
}

pollutant_desc <- function(){

  list_pollutant <- sapply( pollants, function(x){
    paste0("\\code{'", x, "'}: ",
         pollutant_label$label_en[pollutant_label$pollutant %in% x],
         "\n")
  })
  paste0(c("The following pollutants are available :\n", list_pollutant), collapse = "\n")
}
