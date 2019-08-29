pollutant_label <- tibble::tribble(
  ~pollutant, ~label_fr, ~label_en,
  "pm10", "Particules fines inferieures a 10 micrometres", "Particulate matter with a diameter of 10 micrometers or less",
  "pm25", "Particules fines inferieures a 2,5 micrometres", "Particulate matter with a diameter of 2.5 micrometers or less",
  "no2",   "Dioxyde d'azote", "Nitrogen dioxide",
  "nox",   "Oxydes d'azote", "Nitrogen oxide",
  "so2",   "Dioxyde de soufre", "Sulfur dioxide",
  "co", "Monoxyde de carbone", "Carbon monoxide",
  "nh3", "Ammoniac", "Ammonia",
  "covnm", "Composes organiques volatils non methaniques", "Non-methane volatile organic compounds",
  "as", "Arsenic", "Arsenic",
  "cd", "Cadmium", "Cadmium",
  "ni", "Nickel", "Nickel",
  "pb", "Plomb", "Lead",
  "bap", "Benzo(a)pyrene", "Benzo(a)pyrene",
  "co2", "Dioxyde de carbone", "Carbon dioxide",
  "o3", "Ozone", "Ozone"
)
pollutant_label <- as.data.frame(pollutant_label)
usethis::use_data(pollutant_label, overwrite = TRUE)
