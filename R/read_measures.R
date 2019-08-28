#' @importFrom purrr map_chr map_dbl
#' @importFrom utils URLencode
#' @export
#' @title get pollutants measurement
#' @description get measurement of pollutants as a data.frame. Measures
#' unit is microgram per cubic meter.
#' @eval arg_choices("measure", airparis:::pollants)
#' @eval arg_choices("granularity", names(airparis:::granularities))
#' @param dt_start,dt_end limit dates to use as filters. This parameter
#' is mandatory.
#' @param station_id station_id. If NULL, measures from all stations
#' are retrieved. The stations are described in dataset \code{\link{stations}}.
#' @param record_max maximum number of records to read
#' @section available pollutants:
#' The following pollutants are available :
#'
#' \code{'o3'}: ozone
#'
#' \code{'pm10'}: Particulate matter with a diameter of 10 micrometers or less
#'
#' \code{'pm25'}: Particulate matter with a diameter of 2.5 micrometers or less
#'
#' \code{'nox'}: Nitrogen oxide
#'
#' \code{'no2'}: Nitrogen dioxide
#' @note
#' The API of airparif is limiting the number of reacords to maximum
#' 2000 records so it will be necessary to create a loop if more rows are
#' needed.
#' @return a data.frame with the following columns:
#'
#' \code{code_station_ue}: station code where measurements have been carried out.
#'
#' \code{value}: measurements (unit: microgram per cubic meter)
#'
#' \code{date}: date of measurement
#'
#' @examples
#' read_measures()
#' read_measures(measure = "o3", station_id = "4049")
#' read_measures(measure = "nox",
#'   dt_start = as.Date("2018-09-01"),
#'   station_id = "4323")
#' read_measures(measure = "pm10", station_id = "4181",
#'   dt_start = as.Date("2019-06-01"), granularity = "hour")
read_measures <- function( measure = "pm10", granularity = "day",
                           dt_start = Sys.Date() - 7,
                           dt_end = Sys.Date(), station_id = NULL,
                           record_max = 2000){

  if( !measure %in% pollants ){
    stop("measure should be one of the following values: ",
         paste(pollants, collapse = ", ") )
  }
  if( !granularity %in% names(granularities) ){
    stop("granularity should be one of the following values: ",
         paste(names(granularities), collapse = ", ") )
  }

  service <- sprintf("mes_idf_%s_%s", granularities[granularity], measure)

  if( !is.null(dt_start) && !is.null(dt_end)){
    date_filter <- sprintf("date_debut BETWEEN %sT00:00:00Z AND %sT00:00:00Z",
                           format(dt_start, "%Y-%m-%d"),
                           format(dt_end, "%Y-%m-%d")
    )
  } else if( !is.null(dt_start) && is.null(dt_end)){
    date_filter <- sprintf("date_debut AFTER %sT00:00:00Z",
                           format(dt_start-1, "%Y-%m-%d") )
  } else if( is.null(dt_start) && !is.null(dt_end)){
    date_filter <- sprintf("date_debut BEFORE %sT00:00:00Z", format(dt_end+1, "%Y-%m-%d") )
  } else {
    date_filter <- "1=1"
  }
  if( !is.null(station_id)){
    station_filter <- sprintf("code_station_ue='%s'", station_id )
  } else {
    station_filter <- "1=1"
  }
  filters <- paste0(URLencode(date_filter), URLencode(" AND "), URLencode(station_filter))
  maxfeatures <- sprintf("&maxFeatures=%.0f", record_max)
  url <- paste0("https://magellan.airparif.asso.fr/geoserver/DIDON/ows?service=WFS&version=1.0.0&request=GetFeature&",
                "&typeName=DIDON:",service,
                "&propertyname=code_station_ue,valeur,date_debut",
                "&CQL_FILTER=", filters,
                maxfeatures,
                "&outputFormat=application/json")
  data <- read_json(url)
  properties <- map(data$features, "properties")

  out <- data.frame(
    code_station_ue = map_chr(properties, "code_station_ue"),
    value = map_dbl(properties, "valeur"),
    date = as_datetime(map_chr(properties, "date_debut")),
    stringsAsFactors = FALSE
  )

  out
}

