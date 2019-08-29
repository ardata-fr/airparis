#' @importFrom lubridate with_tz
parse_airparif_date <- function(str){
  as.POSIXct(
    with_tz(# Why UT and not Paris time?????
      strptime(str, "%Y-%m-%dT%H:%M:%OS", tz = "UTC"), "Europe/Paris")
  )
}

pollants <- c("o3", "pm10", "pm25", "nox", "no2", "so2")
granularities <- c(hour = "horaire", day = "journalier")

#' @importFrom curl nslookup
#' @title test airparif availability
#' @description check that airparif web services are available.
#' @examples
#' is_magellan_available()
#' @export
is_magellan_available <- function(){
  !is.null(nslookup("magellan.airparif.asso.fr", error = FALSE))
}

