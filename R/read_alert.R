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
