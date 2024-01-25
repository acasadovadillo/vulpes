setwd("/Users/albertocasadovadillo/acv/acv_dir/r")

library(tidyverse)
library(leaflet)
#library(bipartite)
#library(sf)
#library(raster)
#library(rasterVis)
#library(rworldxtra)
#library(leaflet.extras)
#library(mapedit)
#library(ggplot2)
#library(viridis)
#library(rnaturalearth)
library(htmlwidgets)
library(htmltools)
#library(shiny)

df_vulpes_ww <- read.csv("vulpes_all_clear.csv", sep = ";")







colores_especies <- c("red", "darkorchid", "lawngreen", "yellow", "magenta", "cyan", "deepskyblue", "salmon", "orange")
# colores_especies <- rainbow(n = length(unique(df_vulpes_ww$species)))
###listacolores <- as.list(colores_especies)
# Creamos un vector para las diferentes especies
vector_spp <- unique(df_vulpes_ww$species)

# Crear una función para asignar colores a cada especie
asignar_color <- function(factor.especie) {
  colores_especies <- c("red", "darkorchid", "lawngreen", "yellow", "magenta", "cyan", "deepskyblue", "salmon", "orange")  # Puedes agregar más colores según la cantidad de especies
  return(colores_especies[match(vector_spp, unique(df_vulpes_ww$species))])
}

asignar_color <- function(factor_especie) {
  return(colores_especies[match(factor_especie, vector_spp)])
}

m <- leaflet() %>%
  addTiles() %>%
  addProviderTiles("Esri.WorldImagery") %>%
  addCircleMarkers(
    data = df_vulpes_ww,
    lng = ~decimalLongitude,
    lat = ~decimalLatitude,
    color = ~asignar_color(species),
    fillOpacity = 1,
    stroke = FALSE,
    popup = ~species,
    radius = 3,
    group = ~species) %>%
  addLegend("bottomright",   # Puedes ajustar la posición de la leyenda
            colors = colores_especies,  # Puedes ajustar el color de la leyenda
            labels = vector_spp,
            opacity = 1)


m <- leaflet() %>%
  addTiles() %>%
  addProviderTiles("Esri.WorldImagery") %>%
  addCircleMarkers(
    data = df_vulpes_ww[df_vulpes_ww$species == "Vulpes vulpes", ],  # Filtra solo la especie específica
    lng = ~decimalLongitude,
    lat = ~decimalLatitude,
    color = ~asignar_color(species),
    fillOpacity = 1,
    stroke = FALSE,
    popup = ~species,
    radius = 2.3,
    group = ~species
  ) %>%
  addCircleMarkers(
    data = df_vulpes_ww[df_vulpes_ww$species != "Vulpes vulpes", ],    lng = ~decimalLongitude,
    lat = ~decimalLatitude,
    color = ~asignar_color(species),
    fillOpacity = 1,
    stroke = FALSE,
    popup = ~species,
    radius = 2.3,
    group = ~species,
  ) %>%
  addLegend("bottomright",   # Puedes ajustar la posición de la leyenda
            colors = colores_especies,  # Puedes ajustar el color de la leyenda
            labels = vector_spp,
            opacity = 1,
            title = "Especies"
            )

m

# Guardar el mapa en un archivo HTML
saveWidget(m, file = "vulpes_ww.html")
