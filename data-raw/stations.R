#' @export
#' @title measures metadata
#' @description get measures metadata as a data.frame
#' @eval arg_choices("measure", airparis:::pollants)
#' @examples
#' measure_o3_meta <- read_measures_meta(measure = "o3")
#'
#' measure_pm10_meta <- read_measures_meta(measure = "pm10")
#'
#' measure_pm25_meta <- read_measures_meta(measure = "pm25")
#'
#' measure_nox_meta <- read_measures_meta(measure = "nox")
#'
#' measure_no2_meta <- read_measures_meta(measure = "no2")
#' @noRd
read_measures_meta <- function(measure = "pm10"){

  if( !measure %in% pollants ){
    stop("measure should be one of the following values: ",
         paste(pollants, collapse = ", ") )
  }

  service <- sprintf("mes_idf_%s_%s/", "journalier", measure)

  metaurl <- paste0("https://services8.arcgis.com/gtmasQsdfwbDAQSQ/arcgis/rest/services/",
                    service,
                    "FeatureServer/0/query?",
                    "returnDistinctValues=true&returnGeometry=false&",
                    "where=statut_valid=1&",
                    "outFields=nom_com,id_com,nom_station,code_station_ue,x,y&",
                    "f=json&")
  metalist <- read_json(metaurl)
  metalist <- map(metalist$features, "attributes")

  data.frame(stringsAsFactors = FALSE,
             township_name = map_chr(metalist, "nom_com"),
             township_id = map_chr(metalist, "id_com"),
             station_name = map_chr(metalist, "nom_station"),
             station_ue_code = map_chr(metalist, "code_station_ue"),
             station_x = map_dbl(metalist, "x"),
             station_y = map_dbl(metalist, "y")
  )
}
library(purrr)
library(dplyr)
library(jsonlite)

measure_o3_meta <- read_measures_meta(measure = "o3")
measure_o3_meta$o3 <- TRUE
measure_pm10_meta <- read_measures_meta(measure = "pm10")
measure_pm10_meta$pm10 <- TRUE
measure_pm25_meta <- read_measures_meta(measure = "pm25")
measure_pm25_meta$pm25 <- TRUE
measure_nox_meta <- read_measures_meta(measure = "nox")
measure_nox_meta$nox <- TRUE
measure_no2_meta <- read_measures_meta(measure = "no2")
measure_no2_meta$no2 <- TRUE

dat <- list(measure_o3_meta, measure_pm10_meta,
            measure_pm25_meta, measure_nox_meta, measure_no2_meta)

stations <- bind_rows(dat) %>% as_tibble() %>%
  group_by(station_ue_code) %>%
  summarise(
    township_name = head(township_name, 1),
    township_id = head(township_id, 1),
    station_name = head(station_name, 1),
    station_x = head(station_x, 1),
    station_y = head(station_y, 1),
    o3 = sum(o3, na.rm = TRUE)>0,
    pm10 = sum(pm10, na.rm = TRUE)>0,
    pm25 = sum(pm25, na.rm = TRUE)>0,
    nox = sum(nox, na.rm = TRUE)>0,
    no2 = sum(no2, na.rm = TRUE)>0
    ) %>% ungroup() %>%
  as.data.frame()


usethis::use_data(stations, overwrite = TRUE)
