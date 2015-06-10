library(RJSONIO)

#' @title d3.graph
#' @description
#' \code{d3.graph} creates and htmlwidgets using force networks in D3. Inputs must be a data.frame in some specific format.
#' @details
#' Inputs must be a data.frame, not data.table. It is expected to fix this in the future.
#' @param df A data.frame which contains graph data. Some columns are expected. Every row is an edge. \cr
#' \itemize{
#' \item{"source"}{Required column. ID or Label of source/from node of the edge.}
#' \item{"target"}{Required column. ID or Label of target/to node of the edge.}
#' \item{"sourceLabel"}{Optional column. Label of source/from node of the edge}
#' \item{"targetLabel"}{Optional column. Label of target/to node of the edge}
#' \item{"sourceSize"}{Optional column. Size of source node of the edge. ize about 5-10 plots better.}
#' \item{"targetSize"}{Optional column. Size of target node of the edge. ize about 5-10 plots better.}
#' \item{"weight"}{Optional column. Weight of the edge.}
#' }
#' @param circleFillOpacity Opacity of nodes.
#' @param circleStroke Color of stroke of nodes. In any format an html can understand.
#' @param circleStrokeWidth Size of stroke of nodes.
#' @param colors Array of colors in any format an html can understand.
#' @param width Width of svg
#' @param height Height of svg
#' @return An htmlwidget.
#' @import htmlwidgets
#' @export
d3.graph <- function(
  df,
  nodeMinSize = 6,
  nodeMaxSize = 12,
  edgeMinStroke = 0.05,
  edgeMaxStroke = 0.25,
  circleFillOpacity = 1.0,
  circleStroke = "black",
  circleStrokeWidth = 1,
  colors = c("#FF475C","#F65C44","#EE8442","#E5A940","#DDCB3D","#BFD53B","#93CC39","#69C436","#43BB34","#32B344","#30AA5F"),
  width = NULL, height = NULL) {

  if (length(colors)==1) {
    colors = c(colors, colors)
  }
  if ("sourceColor" %in% colnames(df) || "targetColor" %in% colnames(df)) {
    vec = NULL
    if ("sourceColor" %in% colnames(df)) vec = c(vec, df$sourceColor)
    if ("targetColor" %in% colnames(df)) vec = c(vec, df$targetColor)
    vmax <- max(vec)
    vmin <- min(vec)
    if (vmax>vmin) {
      if ("sourceColor" %in% colnames(df)) df$sourceColor = (df$sourceColor-vmin)/(vmax-vmin)
      if ("targetColor" %in% colnames(df)) df$targetColor = (df$targetColor-vmin)/(vmax-vmin)
    } else {
      df$sourceColor = 0.5
      df$targetColor = 0.5
    }
  }
  if ("sourceSize" %in% colnames(df) || "targetSize" %in% colnames(df)) {
    vec = NULL
    if ("sourceSize" %in% colnames(df)) vec = c(vec, df$sourceSize)
    if ("targetSize" %in% colnames(df)) vec = c(vec, df$targetSize)
    vmax <- max(vec)
    vmin <- min(vec)
    if (vmax>vmin) {
      if ("sourceSize" %in% colnames(df)) df$sourceSize = nodeMinSize+(nodeMaxSize-nodeMinSize)*(df$sourceSize-vmin)/(vmax-vmin)
      if ("targetSize" %in% colnames(df)) df$targetSize = nodeMinSize+(nodeMaxSize-nodeMinSize)*(df$targetSize-vmin)/(vmax-vmin)
    } else {
      df$sourceSize = nodeMinSize+(nodeMaxSize-nodeMinSize)*0.5
      df$targetSize = nodeMinSize+(nodeMaxSize-nodeMinSize)*0.5
    }
  }
  if ("weight" %in% colnames(df)) {
    vec = df$weight
    vmax <- max(vec)
    vmin <- min(vec)
    if (vmax>vmin) {
      df$weight = edgeMinStroke+(edgeMaxStroke-edgeMinStroke)*(df$weight-vmin)/(vmax-vmin)
    } else {
      df$weight = edgeMinStroke+(edgeMaxStroke-edgeMinStroke)*0.5
    }
  }

  options = list(
    circleFillOpacity = circleFillOpacity,
    circleStroke = circleStroke,
    circleStrokeWidth = circleStrokeWidth,
    colors = colors
  )

  list_links <- list()
  for (i in 1:nrow(df)) {
    link <- list()

    link[["sourceLabel"]] <- df[i,"source"]
    link[["targetLabel"]] <- df[i,"target"]
    link[["sourceColor"]] <- 0.5
    link[["sourceSize"]] <- 10
    link[["targetColor"]] <- 0.5
    link[["targetSize"]] <- 10
    link[["weight"]] <- 0.2

    for (label in colnames(df)) {
      link[[label]] <- df[i,label]
    }
    list_links[[i]] <- link
  }
  htmlwidgets::createWidget("d3graph", x = list(links = list_links, options = options), width = width, height = height)
}

#' Widget output function for use in Shiny
#'
#' @export
d3.graphOutput <- function(outputId, width = '100%', height = '400px'){
  shinyWidgetOutput(outputId, 'd3graph', width, height, package = 'd3graph')
}

#' Widget render function for use in Shiny
#'
#' @export
renderD3.graph <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  shinyRenderWidget(expr, d3.graphOutput, env, quoted = TRUE)
}