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


#' @title Emissions information for EPCI
#' @description emissions information for epci stored in three
#' data.frame. The dataset contains the
#' following columns:
#'
#' * `gid`: group identifier
#' * `lib_epci`: public intermunicipal cooperation institute name
#' * `annee_inv`: year
#' * `pm10`: Particulate matter with a diameter of 10 micrometers or less (in kg)
#' * `pm25`: Particulate matter with a diameter of 25 micrometers or less (in kg)
#' * `nox`: Nitrogen oxide (in kg)
#' * `so2`: Sulfur dioxide (in kg)
#' * `co`: Carbon monoxide (in kg)
#' * `nh3`: Ammonia (in kg)
#' * `covnm`: Non-methane volatile organic compounds (in kg)
#' * `as`: Arsenic (in kg)
#' * `cd`: Cadmium (in kg)
#' * `ni`: Nickel (in kg)
#' * `pb`: Lead (in kg)
#' * `bap`: Benzo(a)pyrene (in kg)
#' * `co2_t`: Carbon dioxide. Measure for this emission is tons.
#'
#' @docType data
#' @author Airparif
#' @references \url{https://data-airparif-asso.opendata.arcgis.com}
#' @keywords data
"data_emissions_epci"

# https://documenter.getpostman.com/view/2471055/RWaDWrU7?version=latest


#' @title Emissions information for departement
#' @description emissions information for departement stored in three
#' data.frame. The dataset contains the
#' following columns:
#'
#' * `gid`: group identifier
#' * `lib_dep`: township where the station is located
#' * `code_dep`: township where the station is located
#' * `annee_inv`: year
#' * `pm10`: Particulate matter with a diameter of 10 micrometers or less (in kg)
#' * `pm25`: Particulate matter with a diameter of 25 micrometers or less (in kg)
#' * `nox`: Nitrogen oxide (in kg)
#' * `so2`: Sulfur dioxide (in kg)
#' * `co`: Carbon monoxide (in kg)
#' * `nh3`: Ammonia (in kg)
#' * `covnm`: Non-methane volatile organic compounds (in kg)
#' * `as`: Arsenic (in kg)
#' * `cd`: Cadmium (in kg)
#' * `ni`: Nickel (in kg)
#' * `pb`: Lead (in kg)
#' * `bap`: Benzo(a)pyrene (in kg)
#' * `co2_t`: Carbon dioxide. Measure for this emission is tons.
#'
#'
#' @docType data
#' @author Airparif
#' @references \url{https://data-airparif-asso.opendata.arcgis.com}
#' @keywords data
"data_emissions_departement"

# https://documenter.getpostman.com/view/2471055/RWaDWrU7?version=latest


#' @title Emissions information for region
#' @description emissions information for region stored in three
#' data.frame. The dataset contains the
#' following columns:
#'
#' * `gid`: group identifier
#' * `lib_reg`: township where the station is located
#' * `code_reg`: township where the station is located
#' * `annee_inv`: township identifyer
#' * `pm10`: Particulate matter with a diameter of 10 micrometers or less (in kg)
#' * `pm25`: Particulate matter with a diameter of 25 micrometers or less (in kg)
#' * `nox`: Nitrogen oxide (in kg)
#' * `so2`: Sulfur dioxide (in kg)
#' * `co`: Carbon monoxide (in kg)
#' * `nh3`: Ammonia (in kg)
#' * `covnm`: Non-methane volatile organic compounds (in kg)
#' * `as`: Arsenic (in kg)
#' * `cd`: Cadmium (in kg)
#' * `ni`: Nickel (in kg)
#' * `pb`: Lead (in kg)
#' * `bap`: Benzo(a)pyrene (in kg)
#' * `co2_t`: Carbon dioxide. Measure for this emission is tons.
#'
#' @docType data
#' @author Airparif
#' @references \url{https://data-airparif-asso.opendata.arcgis.com}
#' @keywords data
"data_emissions_region"

# https://documenter.getpostman.com/view/2471055/RWaDWrU7?version=latest
