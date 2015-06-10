# install.packages("igraph")
# install.packages("igraphdata")
library(igraph)
library(igraphdata)

devtools::install_github("rocalabern/d3graph")
library(d3graph)

source(paste0(path.package("rWidgets"),"/examples/karate.dump.data.R"))

g1 <- graph.data.frame(karate.data, directed=FALSE)
l <- layout.auto(g1)
plot(g1, layout=l)

g2 <- graph.data.frame(karate.data[,c("fromLabel", "toLabel")], directed=FALSE)
plot(g2, layout=l)

fc <- fastgreedy.community(g1)
colors <- c("#FF6600","#3366FF","#ADD633")
plot(g2, layout=l, vertex.color=colors[fc$membership])

# IDs as labels
df <- data.frame(source=karate.data$fromID, target=karate.data$toID, weight=0.2*karate.data$weight)
d3.graph(df)

# Nombres as labels
df <- data.frame(source=karate.data$fromLabel, target=karate.data$toLabel, weight=0.2*karate.data$weight)
d3.graph(df)

# IDs as labels, and Nombre as labels on mouseover
df <- data.frame(source=karate.data$fromID, target=karate.data$toID,
                 sourceLabel=karate.data$fromLabel, targetLabel=karate.data$toLabel,
                 weight=0.2*karate.data$weight)
d3.graph(df)

# IDs as labels, and Nombre as labels on mouseover
mapColor <- list()
mapColor[fc$names] <- fc$membership
df <- data.frame(source=karate.data$fromID, target=karate.data$toID,
                 sourceLabel=karate.data$fromLabel, targetLabel=karate.data$toLabel,
                 weight=0.2*karate.data$weight,
                 sourceColor=as.numeric(mapColor[as.character(karate.data$fromID)]), targetColor=as.numeric(mapColor[as.character(karate.data$toID)]))
d3.graph(df, colors=c("#FF6600","#3366FF","#ADD633"))

df <- data.frame(source=karate.data$fromLabel, target=karate.data$toLabel,
                 weight=0.2*karate.data$weight,
                 sourceColor=as.numeric(mapColor[as.character(karate.data$fromID)]), targetColor=as.numeric(mapColor[as.character(karate.data$toID)]))
d3.graph(df, colors=c("#FF6600","#3366FF","#ADD633"))


#  Otros parametros
library(data.table)
dt <- data.table(id=c(karate.data$fromID, karate.data$toID))
dt <- dt[, .N, by=id]
mapDegree <- list()
mapDegree[as.character(dt$id)] <- dt$N
df <- data.frame(source=karate.data$fromID, target=karate.data$toID,
                 sourceLabel=karate.data$fromLabel, targetLabel=karate.data$toLabel,
                 weight=0.2*karate.data$weight,
                 sourceSize=2+as.numeric(mapDegree[as.character(karate.data$fromID)]), targetSize=2+as.numeric(mapDegree[as.character(karate.data$toID)]))
d3.graph(df, colors="#FF0000", circleFillOpacity = 0.5, circleStroke = "red", circleStrokeWidth = 4)
