
# Load some packages ####
# These are the packages used in this script
packages <- c('easypackages', 'tidyr', 'ggplot2', 'dplyr', 'scales', 'readxl', 'readr', 'lemon', 'flextable', 'viridis', 'stringr')

# This command installs only those packages (from our object packages) which are not already installed.
install.packages(setdiff(packages, rownames(installed.packages())))

# This loads the packages
easypackages::libraries(packages)

# I use a theme or template of styles for ggplot 
ph_theme = function(){
  theme(
    plot.title = element_text(colour = "#000000", face = "bold", size = 13), # Here in bold
    plot.subtitle = element_text(colour = "#000000", size = 13),
    plot.caption = element_text(colour = "#000000", size = 13),
    plot.title.position = "plot",
    panel.background = element_rect(fill = "#FFFFFF"),
    panel.grid.major.x = element_blank(),
    panel.grid.major.y = element_line(colour = "#E7E7E7", size = .3),
    panel.grid.minor = element_blank(),
    strip.text = element_text(colour = "#000000", size = 13, face = 'bold'),
    strip.background = element_blank(),
    legend.title = element_text(colour = "#000000", size = 10, face = "bold"),
    legend.background = element_rect(fill = "#ffffff"),
    legend.key = element_rect(fill = "#ffffff", colour = "#ffffff"),
    legend.text = element_text(colour = "#000000", size = 10),
    legend.position = 'top',
    axis.ticks = element_line(colour = "#dbdbdb"),
    axis.text.y = element_text(colour = "#000000", size = 11),
    axis.text.x = element_text(colour = "#000000", angle = 90, hjust = 1, vjust = .5, size = 11),
    axis.title =  element_text(colour = "#000000", size = 11, face = "bold"),
    axis.line = element_line(colour = "#dbdbdb"))}

# The Subnational indicators explorer, the first step towards an Explore Subnational Statistics service, promotes transparency and makes it easy for users to access and visualise subnational indicators in one place.

# The indicators are grouped in three categories ("boosting productivity, pay, jobs and living standards", "spreading opportunity and improving public services" and “restoring a sense of community, local pride and belonging”) in line with the Levelling Up the United Kingdom: missions and metrics Technical Annex.

# This tool recreates the explorer on the page:

# https://www.ons.gov.uk/peoplepopulationandcommunity/wellbeing/articles/subnationalindicatorsexplorer/2022-01-06

# To position each local authority within the cloud of local authorities, we used a robust measure of statistical dispersion called the median absolute deviation (MAD). We preferred the MAD to the mean absolute deviation as outliers have a smaller effect on the median than they do on the mean.

# To compute the MAD for a specific indicator, first calculate the median of all values at local authority level for that indicator. Second, subtract the median from each value and get the absolute values. Finally, calculate the median of the median absolute deviations obtained from the previous step and multiply this by 1.4826. This constant is linked to the assumption of normality of the data.

# The distance of each local authority from the centre line (the local authority with the median value in the distribution) is equivalent to the difference between the value of the chosen local authority and the value of the median local authority, divided by the MAD. We consider the resulting score to be positive or negative if the score is at least one MAD above or below the median. Usually, a score is considered to be significantly different from the median score if it is at least two MADs above or below the median.

# Where the score of a local authority is more than 7.5 MADs above or below the score of the median local authority, the local authority is shown at the end of the scale and its position is not fully representative of its score.

# some indicators are only available at upper tier local authority and unitary authority level:

# pupils at expected standards by end of primary school
# schools and nursery schools rated good or outstanding
# persistent absences for all pupils
# persistent absences for pupils eligible for free school meals in the past 6 years
# persistent absences for pupils looked after by local authorities
# female healthy life expectancy
# male healthy life expectancy

raw_df <- read_csv('https://www.ons.gov.uk/visualisations/dvc1786/machine_readable.csv',
                   skip = 1) %>% 
  filter(!str_detect(AREACD, 'S|W')) # removes Scottish and Welsh local authorites

indicators <- raw_df %>% 
  group_by(Category, Indicator) %>% 
  summarise(Records = n())

# Cost of living indicators ####

col_indicator_1 <- raw_df %>% 
  filter(Indicator == 'Gross value added per hour worked') %>% 
  filter(Geography != 'ITL Level 1')



