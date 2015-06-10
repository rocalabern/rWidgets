library(rWidgets)

dfNodes = data.frame(
  name = tolower(letters[1:6]),
  tooltip = paste0("Tooltip ",toupper(letters[1:6])),
  level = c(0,1,1,1,2,2),
  color = rep(rgb(0.2,0.8,0.3),6),
  value = rep(0.5,6)
  )

dfLinks = data.frame(
  tooltip = c("1 -> 2", "1 -> 3", "1 -> 4", "2 -> 5", "2 -> 6", "3 -> 5", "3 -> 6", "4 -> 5", "4 -> 6"),
  source = c(0,0,0,1,1,2,2,3,3),
  target = c(1,2,3,4,5,4,5,4,5),
  color = rep(rgb(0.1,0.3,0.1),9),
  value = rep(0.1,9)
  )

d3.graphSankey(dfNodes, dfLinks)


