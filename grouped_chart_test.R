library(magrittr)
library(ggplot2)

# From source/variables.R in the app folder

shs_colours <- c("#01665e", # Dark green
                 "#57a0d3", # Darkish blue
                 "#81d8d0", # Teal
                 "#7285a5", # Grey
                 "#cc79a7", # Pink
                 "#e69f00", # Yellow
                 "#542788", # Purple
                 "#66a61e", # Green
                 "#d95f02", # Burnt orange
                 "#a6761d", # Yellow-Brown
                 "#666666", # Dark grey
                 "#fb9a99", # Peach
                 "#e31a1c", # Red
                 "#fdbf6f", # Yellow
                 "#ff7f00", # Bright orange
                 "#cab2d6", # Light purple
                 "#6a3d9a", # Strong purple
                 "#ebd72a", # Bright yellow
                 "#b15928"  # Brown
)

# Replicate main_chart_df() section of app.R ####

# From adding saveRDS(main_chart_df, "main_chart_df.Rds") to line 1008 of app.R 
# (the line after main_chart_df <- main_df()) and copying file to this project

main_chart_df <- readRDS("main_chart_df.Rds")

# Exact copy of line 1013 in app.R:

main_chart_df <- main_chart_df[main_chart_df[1] != "All" & main_chart_df[1] != "Base",]

# From running:
# print(chart_data_processing_string(variable_column_names, measure_column_name(), "main_chart_df")))
# on line 1014 
#(before main_chart_df <- suppressWarnings(eval(parse(text = chart_data_processing_string(variable_column_names, 
# measure_column_name(), "main_chart_df")))))

# When copying and pasting print statements, you need to remove escape characters, 
# e.g. find and replace \" with ", and replace \n with a return

main_chart_df <- reshape(main_chart_df, v.names = c("Percent", "LowerConfidenceLimit", "UpperConfidenceLimit"), 
                         idvar = "ID", 
                         direction = "long", 
                         times = c("2018"), 
                         varying = list(Percent = c("2018"), 
                                        LowerConfidenceLimit = c("2018_l"), 
                                        UpperConfidenceLimit = c("2018_u"))) %>% 
  dplyr::select(`blank`, `time`, `Percent`, `LowerConfidenceLimit`, `UpperConfidenceLimit`) %>%
  dplyr::mutate(`Percent`= as.numeric(`Percent`), 
                `LowerConfidenceLimit`= as.numeric(`LowerConfidenceLimit`), 
                `UpperConfidenceLimit`= as.numeric(`UpperConfidenceLimit`))

# Replicate output$main_chart section of app.R (from line 1512) ####

# From running print(bar_chart_string) in app.R on line 1562
# (before 'chart <- suppressWarnings(eval(parse(text = bar_chart_string)))')

ggplot(data = main_chart_df, mapping = aes(x = `time`,
                                           y = `Percent`, 
                                           fill = `blank`, 
                                           text = paste("Value: ", Percent, "%", "\n",
                                                        "Lower Confidence Limit: ", main_chart_df$LowerConfidenceLimit, "%", "\n",
                                                        "Upper Confidence Limit: ", main_chart_df$UpperConfidenceLimit, "%", "\n",                                                                                        
                                                        "Group: ",time))) +
  geom_bar(position = "dodge", stat = "identity") +
  theme(panel.grid.minor = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.grid.major.y = element_line(colour = "#b8b8ba", size = 0.3),
        panel.background = element_rect("transparent"), legend.title = element_blank(), legend.position = "bottom") + 
  scale_fill_manual(values = shs_colours)

# Removed the 'labs' part at the end as not necessary here.

