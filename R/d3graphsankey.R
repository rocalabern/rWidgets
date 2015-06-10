library(htmlwidgets)

# data.frameToList <- function (df) {
#   output = list()
#   for (col in colnames(df)) {
#     output[[col]] = df[,col]
#   }
#   return(output)
# }

#' @title d3.graphSankey
#' @description
#' \code{d3.graphSankey} creates and htmlwidgets using sankey in D3. Inputs must be a couple of data.frames in some specific format.
#' @details
#' Inputs must be a couple of data.frames.
#' @param dfNodes A data.frame which contains nodes data. Some columns are expected. Every row is a node. \cr
#' \itemize{
#' \item{"name"}{Optional column. Name}
#' \item{"tooltip"}{Optional column. Tooltip}
#' \item{"level"}{Required column. Horizontal position (it must start at 0 to n without holes.}
#' \item{"color"}{Required column. Color of the node}
#' \item{"value"}{Required column. Vertical size of nodes.}
#' }
#' @param dfLinks A data.frame which contains links data. Some columns are expected. Every row is a link \cr
#' \itemize{
#' \item{"tooltip"}{Optional column. Tooltip}
#' \item{"source"}{Required column. Source node. It must be integer. It is the position in nodes data.frame starting at 0.}
#' \item{"target"}{Required column. Target node. It must be integer. It is the position in nodes data.frame starting at 0.}
#' \item{"color"}{Required column. Color of the link}
#' \item{"value"}{Required column. Stroke width of link.}
#' }
#' @param nodeWidth Width of nodes.
#' @param strokeOpacity Opacity of links.
#' @return An htmlwidget.
#' @import htmlwidgets
#' @export
d3.graphSankey <- function(
  dfNodes,
  dfLinks,
  nodeWidth = 15,
  strokeOpacity = 0.2,
  width = NULL, height = NULL) {

  options = list(
    nodeWidth = nodeWidth,
    strokeOpacity = strokeOpacity
  )

#   if (utils::packageVersion("htmlwidgets")>="0.4") {
#     widget = htmlwidgets::createWidget("d3graphsankey",
#                               x = list(
#                                 nodes = data.frameToList(dfNodes),
#                                 links = data.frameToList(dfLinks),
#                                 options = options),
#                               width = width, height = height)
#   } else {
    widget = htmlwidgets::createWidget("d3graphsankey",
                              x = list(
                                nodes = dfNodes,
                                links = dfLinks,
                                options = options),
                              width = width, height = height)
#   }
  return(widget)
}

#' Widget output function for use in Shiny
#'
#' @export
d3.graphSankeyOutput <- function(outputId, width = '100%', height = '400px'){
  shinyWidgetOutput(outputId, 'd3graphsankey', width, height, package = 'd3graphsankey')
}

#' Widget render function for use in Shiny
#'
#' @export
renderD3.graphSankey <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  shinyRenderWidget(expr, d3.graphSankeyOutput, env, quoted = TRUE)
}