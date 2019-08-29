#' @title Pollutant labels
#' @description Description of pollutants in a data.frame.
#'
#' * `pollutant`: short code for a pollutant
#' * `label_fr`: french label of pollutant
#' * `label_en`: english label of pollutant
#'
#' @docType data
#' @keywords data
#' @name pollutant_label
"pollutant_label"


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
#' @keywords data
#' @name stations
#' @family datasets from airparif
"stations"

# https://documenter.getpostman.com/view/2471055/RWaDWrU7?version=latest

# library(dplyr)
# replace_labels <- function(dat){
#   dat$label_en[is.na(dat$label_en)] <- dat$name[is.na(dat$label_en)]
#   dat
# }
# tibble(name = names(emissions_epci)) %>%
#   left_join(pollutant_label, by = c("name"="pollutant")) %>%
#   replace_labels() %>%
#   mutate(str = glue::glue("#' * `{name}`: {label_en}")) %>%
#   pull(str) %>% cat(sep = "\n")


#' @title Pollutants emissions for 2015 by EPCI
#' @description EPCI (Etablissement public de cooperation intercommunale) pollutants emissions
#' as a data.frame. The dataset contains the following columns:
#'
#' * `gid`: geographical id
#' * `lib_epci`: EPCI label (EPCI is an administrative division in France)
#' * `year`: year of emissions
#' * `pm10`: Particulate matter with a diameter of 10 micrometers or less (in kg)
#' * `pm25`: Particulate matter with a diameter of 2.5 micrometers or less (in kg)
#' * `nox`: Nitrogen oxide (in kg)
#' * `so2`: Sulfur dioxide (in kg)
#' * `co`: Carbon monoxide (in kg)
#' * `nh3`: Ammonia (in in kg)
#' * `covnm`: Non-methane volatile organic compounds (in kg)
#' * `co2`: Carbon dioxide (in ton)
#'
#' @docType data
#' @keywords data
#' @name emissions_epci
#' @family datasets from airparif
"emissions_epci"

#' @title Pollutants emissions for 2015 by departement
#' @description Departement pollutants emissions
#' as a data.frame. The dataset contains the following columns:
#'
#' * `gid`: geographical id
#' * `lib_dep`: departement label
#' * `code_dep`: departement code
#' * `year`: year of emissions
#' * `pm10`: Particulate matter with a diameter of 10 micrometers or less (in kg)
#' * `pm25`: Particulate matter with a diameter of 2.5 micrometers or less (in kg)
#' * `nox`: Nitrogen oxide (in kg)
#' * `so2`: Sulfur dioxide (in kg)
#' * `co`: Carbon monoxide (in kg)
#' * `nh3`: Ammonia (in in kg)
#' * `covnm`: Non-methane volatile organic compounds (in kg)
#' * `co2`: Carbon dioxide (in ton)
#'
#' @docType data
#' @keywords data
#' @name emissions_departement
#' @family datasets from airparif
"emissions_departement"

#' @title Pollutants emissions for 2015 by region
#' @description Regional pollutants emissions
#' as a data.frame. The dataset contains the following columns:
#'
#' * `gid`: geographical id
#' * `lib_reg`: region label
#' * `code_reg`: region code
#' * `year`: year of emissions
#' * `pm10`: Particulate matter with a diameter of 10 micrometers or less (in kg)
#' * `pm25`: Particulate matter with a diameter of 2.5 micrometers or less (in kg)
#' * `nox`: Nitrogen oxide (in kg)
#' * `so2`: Sulfur dioxide (in kg)
#' * `co`: Carbon monoxide (in kg)
#' * `nh3`: Ammonia (in in kg)
#' * `covnm`: Non-methane volatile organic compounds (in kg)
#' * `co2`: Carbon dioxide (in ton)
#'
#' @docType data
#' @keywords data
#' @name emissions_region
#' @family datasets from airparif
"emissions_region"
