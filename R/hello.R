pollants <- c("o3", "pm10", "pm25", "nox", "no2")
granularities <- c(hour = "horaire", day = "journalier")


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
#' @examples
#' read_atmo()
read_atmo <- function( ){

  atmo_url <- paste0("https://magellan.airparif.asso.fr/geoserver/DIDON/ows?service=WFS&version=1.0.0&request=GetFeature",
    "&typeName=DIDON:ind_idf_agglo&outputFormat=application%2Fjson&propertyname=date_ech,valeur",
    "&maxFeatures=400")
  data <- read_json(atmo_url)

  properties <- map(data$features, "properties")

  data.frame(
    date = as_date(map_chr(properties, "date_ech")) + 1,
    score = map_int(properties, "valeur")
  )
}


#' @importFrom purrr map_chr map_dbl
#' @importFrom utils URLencode
#' @export
#' @title get pollutants measurement
#' @description get measurement of pollutants as a data.frame
#' @eval arg_choices("measure", airparis:::pollants)
#' @eval arg_choices("granularity", names(airparis:::granularities))
#' @param dt_start,dt_end limit dates to use as filters. This parameter
#' is mandatory.
#' @param station_id station_id. If NULL, measures from all stations
#' are retrieved.
#' @param record_max maximum number of records to read
#' @note
#' The API of airparif is limiting the number of reacords to maximum
#' 2000 records.
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
                           record_max = 10000){

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
    date_debut = as_datetime(map_chr(properties, "date_debut")),
    stringsAsFactors = FALSE
    )

  out
}


#' @export
##' @title Pollution outbreak alerts
##' @importFrom lubridate as_datetime
read_alert <- function( ){

  url <- paste0("https://magellan.airparif.asso.fr/geoserver/DIDON/ows?service=WFS&version=1.0.0",
    "&request=GetFeature&typeName=DIDON:alrt_idf",
    "&propertyname=date_echeance,code_zone,lib_geo,polluant,param_seuil,param_critere_population,param_critere_superficie",
    "&CQL_FILTER=param_seuil=1",
    "&maxFeatures=2000",
    "&outputFormat=application%2Fjson")
  data <- read_json(url)

  properties <- map(data$features, "properties")

  polluant <- map_chr(properties, "polluant", .default = NA_character_)

  seuil <- map_int(properties, "param_seuil") + 1
  seuil <- c( "none","info", "alert")[seuil]

  crit_pop <- map_int(properties, "param_critere_population")
  crit_surf <- map_int(properties, "param_critere_superficie")

  out <- data.frame(
    date_echea = as_datetime(map_chr(properties, "date_echeance")),
    pollutant = as.character(c("5" = "pm10", "7" = "o3", "8" = "no2")[polluant]),
    seuil = seuil,
    crit_pop = crit_pop > 0,
    param_cri0 = crit_surf > 0,
    stringsAsFactors = FALSE
  )

  out
}

#' @title Stations information
#' @description Stations information stored in a
#' data.frame. The dataset contains the following columns:
#'
#' * `station_ue_code`: european unique code for the station
#' * `township_name`: township where the station is located
#' * `township_id`: township identifyer
#' * `station_name`: station name
#' * `station_x`: x coordinate the station (lambert 93)
#' * `station_y`: y coordinate the station (lambert 93)
#' * `o3`: wether o3 is measured at this station
#' * `pm10`: wether pm10 is measured at this station
#' * `pm25`: wether pm25 is measured at this station
#' * `nox`: wether nox is measured at this station
#' * `no2`: wether no2 is measured at this station
#'
#' @docType data
#' @author Airparif
#' @references \url{https://data-airparif-asso.opendata.arcgis.com}
#' @keywords data
"stations"

# https://documenter.getpostman.com/view/2471055/RWaDWrU7?version=latest
