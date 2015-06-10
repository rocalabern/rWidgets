HTMLWidgets.widget({

  name: 'd3graphsankey',

  type: 'output',

  initialize: function(el, width, height) {
    var svg = d3.select(el).append("svg")
      .attr("width", width)
      .attr("height", height)
      .append("g")

    return {
          svg: svg,
          x: null
        };
  },

  resize: function(el, width, height, instance) {
    d3.select(el).select("svg")
      .attr("width", width)
      .attr("height", height);

    this.renderValue(el, instance.x, instance);
  },

  renderValue: function(el, x, instance) {
    var svg = instance.svg;
    instance.x = x;
    var width = el.offsetWidth;
    var height = el.offsetHeight;

    var nodes = HTMLWidgets.dataframeToD3(x.nodes);
    var links = HTMLWidgets.dataframeToD3(x.links);
//    var nodes = HTMLWidgets.dataframeToD3(x.nodes[0]);
//    var links = HTMLWidgets.dataframeToD3(x.links[0]);

  svg.selectAll("*").remove();

  var sankey = d3.sankey(width)
    .nodeWidth(x.options.nodeWidth)
    .nodePadding(10)
    .size([width, height]);

  var path = sankey.link();

  sankey
    .nodes(nodes)
    .links(links)
    .layout(32);

  var link = svg.append("g").selectAll(".link")
      .data(links)
      .enter().append("path")
      .attr("class", "link")
      .attr("d", path)
      .style("stroke-width", function(d) { return Math.max(1, d.dy); })
      .style("stroke", function(d) { return d.color; })
      .style("fill", "none")
      .style("stroke-opacity", x.options.strokeOpacity)
      .sort(function(a, b) { return b.dy - a.dy; });

   link.append("title")
      .text(function(d) { if(d.tooltip) { return d.tooltip; } else { return ""; } });

  var node = svg.append("g").selectAll(".node")
      .data(nodes)
      .enter().append("g")
      .attr("class", "node")
      .attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; })
      .call(d3.behavior.drag()
      .origin(function(d) { return d; })
      .on("dragstart", function() { this.parentNode.appendChild(this); })
      .on("drag", dragmove));

  node.append("rect")
      .attr("height", function(d) { return d.dy; })
      .attr("width", sankey.nodeWidth())
      .style("fill", function(d) { return d.color; })
      .style("stroke", function(d) { return d3.rgb(d.color).darker(2); })
      .append("title")
      .text(function(d) { if(d.tooltip) {return d.tooltip;} else { return ""} });

  node.append("text")
      .attr("x", -6)
      .attr("y", function(d) { return d.dy / 2; })
      .attr("dy", ".35em")
      .attr("text-anchor", "end")
      .attr("transform", null)
      .text(function(d)  { if(d.name) { return d.name; } else { return ""; } })
      .filter(function(d) { return d.x < width / 2; })
      .attr("x", 6 + sankey.nodeWidth())
      .attr("text-anchor", "start");

  function dragmove(d) {
    d3.select(this).attr("transform", "translate(" + d.x + "," + (d.y = Math.max(0, Math.min(height - d.dy, d3.event.y))) + ")");
    sankey.relayout();
    link.attr("d", path);
  };

  }

});
