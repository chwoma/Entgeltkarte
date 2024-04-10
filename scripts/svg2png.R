library(rsvg)

#convert svg to png
liste_svg <- list.files(here("output"), pattern = ".svg")
for (i in 1:length(liste_svg)) {
  rsvg_png(
    here("output",liste_svg[i]),
    file = sub(".svg", ".png", here("output",liste_svg[i])),
    width = 900,
    height = 1600
  )
}