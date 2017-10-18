# GENERAL SETUP ###############################################################

# A script to replicate these two figures from the SDG atlas:
# https://www.dropbox.com/s/4y91t3xchldfnc3/Screenshot%202017-10-18%2011.13.43.png?dl=0

library(ggplot2)
library(extrafont)
library(dplyr)

library(wbgcharts)
library(wbgmaps)
library(wbggeo)

style <- style_atlas()














# IMPORTING DATA ###############################################################

# Import the data from API
indicators <- c("SH.H2O.SAFE.ZS", "SH.H2O.SAFE.RU.ZS")
df <- wbgdata(
  country = "countries_only",
  indicator = indicators,
  startdate = 2012, enddate = 2012,
  indicator.wide = FALSE, cache = wbgcharts:::wb_newcache
)

# Preview the data - but we can't edit b/c
# REPRODUCIBILITY
View(df)











# TRANSFORMING DATA ############################################################

# Instead we have to edit the data through code - find the bottom 30 by rural
bottom <- df %>%
  filter(complete.cases(.)) %>%
  filter(indicatorID == "SH.H2O.SAFE.RU.ZS") %>%
  arrange(-value) %>%
  tail(30) %>%
  pull(iso3c)

df_dotplot <- df %>%
  filter(complete.cases(.)) %>%
  filter(iso3c %in% bottom) %>%
  mutate(iso3c = factor(iso3c, levels = bottom))

# Check the data again
head(df_dotplot %>% arrange(iso3c, indicatorID))








# VISUALIZATION ################################################################

# Simple plot - then move legend, col, bar, then facetted bar, etc...
# QUICK PROTOTYPING
ggplot(data = df_dotplot, aes(x = value, y = iso3c, color = indicatorID)) +
  geom_point()


















# ADVANCED VISUALISATION #######################################################

# Styled plot - FLEXIBILITY
p <- ggplot(
  data = df_dotplot,
  aes(x = value, y = iso3c, color = indicatorID, shape = indicatorID)
) +
  geom_other_dotplot(aes(y = iso3c), size.line = 0.25) +
  geom_other_dotplot_label(
    aes(x = value, y = iso3c, label = wbgref$countries$labels[as.character(iso3c)]),
    nudge_x = -1,
    size = style$gg_text_size * 0.8, color = style$theme()$text$colour,
    family = style$theme()$text$family
  ) +
  scale_x_continuous(limits = c(20, 80)) +
  scale_color_manual(values=style$colors$categorical, labels = c("Rural", "National")) +
  scale_shape_manual(values=style$shapes$categorical, labels = c("Rural", "National")) +
  style$theme() + style$theme_barchart() +
  theme(axis.text.y = element_blank(),
        legend.position = c(0.9,1), legend.justification = c(1,1),
        legend.direction = "horizontal", legend.margin = margin())

p

grid::grid.newpage()
figure(
  p,
  title = "People in rural areas suffer from especially low access to water...",
  subtitle = "Share of population with access to an improved water source, national average and rural, 2012 (%)",
  source = paste("Source:", wbg_source(indicators))
)








# A DIFFERENT VISUALIZATION ####################################################

# Let's depict (some of) the same data on a map
df_map <- df %>%
  filter(indicatorID == "SH.H2O.SAFE.ZS")

# Check the data again
head(df_map)

df_map$bin <- supercut(
    df_map$value,
    c("[0,25)","[25,50)","[50,75)", "[75,100]"),
    c("0-25", "25-50", "50-75", "75-100")
)

# Check the data again
head(df_map)

pg <- wbg_choropleth(
  df_map, wbgmaps[["low"]], style, "bin", aspect_ratio = 1
)

grid::grid.newpage()
figure(
  pg,
  theme = style$theme(),
  aspect_ratio = 5/4,
  title = "Those who lack improved water sources are concentrated largely in Sub-Saharan Africa",
  subtitle = wbg_name(indicators[1]),
  source = paste("Source:", wbg_source(indicators[1]))
)
