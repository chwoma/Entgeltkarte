library("here")
library("sf")
library("rmapshaper")
library("ggplot2")
library("showtext")

##data
#geo data
#https://gdz.bkg.bund.de/index.php/default/verwaltungsgebiete-1-5-000-000-stand-31-12-vg5000-12-31.html
kreise <-
  st_read(here("input",
               "VG5000_KRS.shp"))
laender <-
  st_read(here("input",
               "VG5000_LAN.shp"))
laender <- laender[1:16, ]
#simplify geometry
kreise <- ms_simplify(kreise, .3)
laender <- ms_simplify(laender, .3)
#only inner lines
kreise_il <- ms_innerlines(kreise)
laender_il <- ms_innerlines(laender)

#income data
#https://statistik.arbeitsagentur.de/Statistikdaten/Detail/202212/iiia6/beschaeftigung-entgelt-entgelt/entgelt-dwolk-0-202212-xlsx.xlsx?__blob=publicationFile&v=4
entgelt <-
  read.csv2(
    file = here("input", "entgelt_2022.csv"),
    skip = 2,
    header = TRUE,
    colClasses = c("character", "character", rep("numeric", 3)),
    encoding = "UTF-8"
  )
names(entgelt)[1] <- "ARS"
entgelt$paygap <-
  entgelt$medianentgelt_male - entgelt$medianentgelt_female

#merge
kreise_daten <- merge(kreise, entgelt, by = "ARS")
#statistical measures
max_paygap <- max(kreise_daten$paygap)
min_paygap <- min(kreise_daten$paygap)
d_paygap <- 366 #pay gap nationwide
max_paygap_txt <-
  paste0(format(round(max_paygap, 0), big.mark = "."), " €")
min_paygap_txt <-
  paste0(format(round(min_paygap, 0), big.mark = "."), " €")
d_paygap_txt <- paste0(format(d_paygap, big.mark = "."), " €")


##design
#colors
lowcol <- rgb(255, 0, 0, maxColorValue = 255) #red
highcol <- rgb(0, 0, 255, maxColorValue = 255) #blue
midcol <- "white"
graulegende <- rgb(64, 64, 64, maxColorValue = 255)

source(here("scripts", "theme_entgelt.R"))
set_theme_entgelt()

#set text
font_add_google("Catamaran")
#automatically use showtext to render text
showtext_auto()

##plot
paygapkarte <- ggplot() +
  geom_sf(data = kreise_daten, aes(fill = paygap), color = "NA") +
  geom_sf(
    data = kreise,
    fill = NA,
    color = graulegende,
    size = .2
  ) +
  geom_sf(data = laender_il, color = graulegende, size = .5) +
  scale_fill_gradient2(
    "",
    low = lowcol,
    mid = midcol,
    high = highcol,
    midpoint = 0,
    limits = c(min_paygap, max_paygap),
    breaks = c(min_paygap, 0, d_paygap, max_paygap),
    labels = c(min_paygap_txt, "0 €", d_paygap_txt, max_paygap_txt)
  ) +
  labs(title = "High gender pay gap in the industrial south",
       subtitle = "differences in monthly salaries of male and female employees\nGerman districts; december 2022",
       caption = "© design: chowma, data: Statistik der Bundesagentur für Arbeit")

ggsave(
  file = here("output", "map_genderpaygap.svg"),
  plot = paygapkarte,
  width = 4.5,
  height = 8,
  bg = "white"
)

##svg to png
source(here("scripts", "svg2png.R"))
