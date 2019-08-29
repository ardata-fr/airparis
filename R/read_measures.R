#' @importFrom purrr map_chr map_dbl
#' @importFrom lubridate days minutes
#' @importFrom utils URLencode
#' @export
#' @title get pollutants measurements
#' @description get measurements of pollutants as a data.frame. All measures
#' are using unit microgram per cubic meter.
#' @eval arg_choices("pollutant", airparis:::pollants)
#' @eval arg_choices("granularity", names(airparis:::granularities))
#' @param dt_start,dt_end limit dates (character formated as `%Y-%m-%d``) to use as filters. This parameter
#' is mandatory.
#' @param station_id station_id. If NULL, measures from all stations
#' are retrieved. The stations are described in dataset \code{\link{stations}}.
#' @param record_max maximum number of records to read
#' @section available pollutants:
#'
#' The following pollutants are available :
#'
#' * `o3`: ozone
#' * `pm10`: Particulate matter with a diameter of 10 micrometers or less
#' * `pm25`: Particulate matter with a diameter of 2.5 micrometers or less
#' * `nox`: Nitrogen oxide
#' * `no2`: Nitrogen dioxide
#' @note
#' The API of airparif is limiting the number of records to 2000;
#' it is necessary to loop over dates or stations when more rows are
#' needed.
#' @return a data.frame with the following columns:
#'
#' * `code_station_ue`: *(character)*, station code where measurements have been carried out.
#' * `value`: *(double)*, measurements (unit: microgram per cubic meter)
#' * `date_time`: *(POSIXct with time zone set to `Europe/Paris`)*, date-time of measurement
#' * `pollutant`: *(character)*, pollutant
#'
#' @examples
#' if( is_magellan_available() ){
#'
#' read_measures()
#' read_measures(pollutant = "pm10", station_id = "4002")
#' read_measures(pollutant = "pm25", station_id = "4002")
#' read_measures(pollutant = "o3", station_id = "4049")
#' read_measures(pollutant = "nox", station_id = "4002")
#' read_measures(pollutant = "no2", station_id = "4002")
#' read_measures(pollutant = "nox",
#'   dt_start = as.Date("2018-09-01"),
#'   station_id = "4323")
#' read_measures(pollutant = "pm10", station_id = "4181",
#'   dt_start = as.Date("2019-06-01"), granularity = "hour")
#'
#' }
#' @family functions about Paris air quality
#' @seealso [stations], [is_magellan_available()]
read_measures <- function( pollutant = "pm10", granularity = "day",
                           dt_start = format(Sys.Date() - 7),
                           dt_end = format(Sys.Date()-1), station_id = NULL,
                           record_max = 2000){

  dt_start <- with_tz(strptime(dt_start, "%Y-%m-%d", tz = "Europe/Paris"), "UTC")
  dt_end <- with_tz(strptime(dt_end, "%Y-%m-%d", tz = "Europe/Paris") + days(1) - lubridate::minutes(1), "UTC")

  if( !is.character(pollutant) && length(pollutant) != 1 ){
    stop("pollutant should be a unique character vector")
  }

  if( !pollutant %in% pollants ){
    stop("pollutant should be one of the following values: ",
         paste(pollants, collapse = ", ") )
  }

  if( !granularity %in% names(granularities) ){
    stop("granularity should be one of the following values: ",
         paste(names(granularities), collapse = ", ") )
  }

  service <- sprintf("mes_idf_%s_%s", granularities[granularity], pollutant)

  if( !is.null(dt_start) && !is.null(dt_end)){
    date_filter <- sprintf("date_debut BETWEEN %s AND %s",
                           format(dt_start, "%Y-%m-%dT%H:%M:%SZ"),
                           format(dt_end, "%Y-%m-%dT%H:%M:%SZ")
    )
  } else if( !is.null(dt_start) && is.null(dt_end)){
    date_filter <- sprintf("date_debut AFTER %s",
                           format(dt_start-1, "%Y-%m-%dT%H:%M:%SZ") )
  } else if( is.null(dt_start) && !is.null(dt_end)){
    date_filter <- sprintf("date_debut BEFORE %s", format(dt_end+1, "%Y-%m-%dT%H:%M:%SZ") )
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

  date_ <- parse_airparif_date(map_chr(properties, "date_debut"))

  out <- data.frame(
    code_station_ue = map_chr(properties, "code_station_ue"),
    value = map_dbl(properties, "valeur"),
    date_time = date_,
    pollutant = rep(pollutant, length(date_)),
    stringsAsFactors = FALSE
  )

  out
}

