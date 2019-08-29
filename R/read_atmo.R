#' @importFrom purrr map map_dbl map_int
#' @importFrom jsonlite read_json
#' @importFrom lubridate as_date
#' @export
#' @title ATMO index data
#' @description get ATMO index data as a data.frame.
#' The data is only containing the last year of daily historic.
#' @details
#' The air quality index ranges from 1 (very good) to 10 (very bad).
#' It characterizes in a simple and comprehensive way the air quality
#' of an urban agglomeration.
#'
#' It is composed of 4 sub index (all ranging from 1 to 10), each being
#' representative of an air pollutant:
#'
#' * fine particles (PM10)
#' * ozone (O3)
#' * nitrogen dioxide (NO2)
#' * sulfur dioxide (SO2)
#'
#' The highest sub-index of the 4 presented above will be the index of the day.
#'
#' It is not possible to reproduce exact calculations as `so2` is not available
#' through the web service or with [read_measures()].
#' @return a data.frame with the following columns:
#'
#' * `date_time`: *(POSIXct with time zone set to `Europe/Paris`)*, date-time of index
#' * `score`: *(integer)*, air quality index
#' @examples
#' if( is_magellan_available() ){
#'   read_atmo()
#' }
#' @family functions about Paris air quality
read_atmo <- function( ){

  atmo_url <- paste0("https://magellan.airparif.asso.fr/geoserver/DIDON/ows?service=WFS&version=1.0.0&request=GetFeature",
                     "&typeName=DIDON:ind_idf_agglo&outputFormat=application%2Fjson&propertyname=date_ech,valeur",
                     "&maxFeatures=400")
  data <- read_json(atmo_url)

  properties <- map(data$features, "properties")
  data.frame(
    date_time = parse_airparif_date(map_chr(properties, "date_ech")),
    score = map_int(properties, "valeur")
  )
}
