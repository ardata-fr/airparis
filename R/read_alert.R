#' @export
#' @title air quality alerts
#' @description read air quality alerts issued by airparif.
#' @return a data.frame with the following columns:
#'
#' * `date_time`: *(POSIXct with time zone set to `Europe/Paris`)*, date-time of measurement
#' * `pollutant`: *(character)*, pollutant whose level has triggered the alert
#' * `state`: *(character)*, state of the alert, a label meaning information and alert - coded as
#' `c("Niveau d'information et de recommandation or alert", "Niveau d'alerte")`.
#' @importFrom lubridate as_datetime
#' @examples
#' if( is_magellan_available() ){
#'   read_alert()
#' }
#' @family functions about Paris air quality
read_alert <- function( ){

  str_fields <- c("date_ech", "etat", "code_pol")

  url <- paste0("https://magellan.airparif.asso.fr/geoserver/DIDON/ows?service=WFS&version=1.0.0",
                "&request=GetFeature&typeName=DIDON:alrt_idf",
                "&propertyname=", paste0(str_fields, collapse = ","),
                "&maxFeatures=2000",
                "&outputFormat=application%2Fjson")
  data <- read_json(url)
  properties <- map(data$features, "properties")

  data <- lapply(str_fields,
                     function(field, properties){
                       map_chr(properties, field, .default = NA_character_)
                     },
                     properties = properties)
  names(data) <- str_fields

  out <- data.frame(
    date_time = parse_airparif_date(data$date_ech),
    pollutant = as.character(c("5" = "pm10", "7" = "o3", "8" = "no2")[data$code_pol]),
    state = data$etat,
    stringsAsFactors = FALSE
  )

  out
}
