#function to set individual theme
set_theme_entgelt <- function() {
  theme_set(theme_void())
  theme_update(
    plot.title = element_text(
      size = rel(1.2),
      hjust = 0,
      face = "bold",
      family = "Raleway"
    ),
    plot.subtitle = element_text(size = rel(.8), hjust = 0, family = "Raleway"),
    plot.caption = element_text(size = rel(.7), hjust = 1,  family = "Raleway"),
    plot.caption.position =  "plot",
    legend.title = element_text(size = rel(.8), family = "Raleway"),
    legend.text = element_text(size = rel(.8),family = "Raleway"),
    plot.margin = margin(
      t = 15,
      #Top
      r = 15,
      #Right
      b = 15,
      #Bottom
      l = 15
    )  #Left
  )
}
