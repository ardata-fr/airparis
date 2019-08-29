arg_choices <- function(name, choices){
  paste0("@param ", name, " one of the following values: ", paste(shQuote(choices), collapse = ", "), ".")
}
