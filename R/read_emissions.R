geo_emi <- c("epci", "departement", "region")



#' @export
#' @importFrom purrr map_int map_chr map_dbl
#' @title air pollutant emissions
#' @description Air pollutant emissions for 2015. Pollutant emissions are the
#' quantities of pollutants directly released into the atmosphere by human
#' activities or by natural sources.
#' @eval arg_choices("geo", airparis:::geo_emi)
#' @examples
#' read_emissions(geo = "epci")
#'
#' read_emissions(geo = "departement")
#'
#' read_emissions(geo = "region")
read_emissions <- function( geo = "epci" ){

  if( !geo %in% geo_emi){
    stop("expected value for geo is one of: ", paste0(geo_emi))
  }
  if( length( geo) != 1 || !is.character(geo) ){
    stop("geo should be one of: ", paste0(geo_emi))
  }


  fields <- c("pm10_kg", "nox_kg", "so2_kg", "pm25_kg", "co_kg", "nh3_kg",
              "covnmkg", "as_kg", "cd_kg", "ni_kg", "pb_kg", "bap_kg", "co2_t")
  str_fields <- c("gid")
  int_fields <- c("annee_inv")

  if( geo %in% "epci"){
    str_fields <- c(str_fields, "lib_epci")
  } else if(geo %in% "region"){
    str_fields <- c(str_fields, "lib_reg", "code_reg")
  } else if(geo %in% "departement"){
    str_fields <- c(str_fields, "lib_dep", "code_dep")
  }

  year <- 2015
  service <- sprintf("emi_idf_%s_%s", geo, year)

  sel <- paste0(c(str_fields, int_fields, fields), collapse = ",")

  url <- paste0("https://magellan.airparif.asso.fr/geoserver/DIDON/ows?service=WFS&version=1.0.0",
                "&request=GetFeature",
                "&typeName=DIDON:",service,
                "&propertyname=", sel,
                "&maxFeatures=1000",
                "&outputFormat=application%2Fjson")

  data <- read_json(url)
  properties <- map(data$features, "properties")

  str_data <- lapply(str_fields,
                     function(field, properties){
                       map_chr(properties, field)
                     },
                     properties = properties)
  names(str_data) <- str_fields

  int_data <- lapply(int_fields,
                     function(field, properties){
                       map_int(properties, field)
                     },
                     properties = properties)
  names(int_data) <- int_fields

  dbl_data <- lapply(fields,
                     function(field, properties){
                       as.double(sub(pattern = "N/D", replacement = "", x = map(properties, field) ))
                     },
                     properties = properties)
  names(dbl_data) <- fields

  out <- str_data
  out[names(int_data)] <- int_data
  out[names(dbl_data)] <- dbl_data

  out <- as.data.frame(out, stringsAsFactors = FALSE)
  out
}
