HTMLWidgets.widget({

  name: 'd3graph',

  type: 'output',

  initialize: function(el, width, height) {
    d3.select(el).append("svg")
      .attr("width", width)
      .attr("height", height);

    d3.select(el).select("svg").selectAll("*").remove();

    return d3.layout.force();
  },

  resize: function(el, width, height, force) {
    d3.select(el).select("svg")
      .attr("width", width)
      .attr("height", height);

    force.size([width, height]).resume();
  },

  renderValue: function(el, x, force) {
    var links = x.links;
    var options = x.options;

    var colors =  options.colors;
    var nodeColor = d3.scale.quantize().domain([0, 1]).range(colors);

    d3.select(el).select("svg").selectAll("*").remove();

    var nodes = {};

    // Compute the distinct nodes from the links.
    links.forEach(function(link) {
      link.source = nodes[link.source] || (nodes[link.source] = {id: link.source, name: link.source, label: link.sourceLabel, size: link.sourceSize, color: nodeColor(link.sourceColor), weight: link.weight});
      link.target = nodes[link.target] || (nodes[link.target] = {id: link.target, name: link.target, label: link.targetLabel, size: link.targetSize, color: nodeColor(link.targetColor), weight: link.weight});
    });

    var width = el.offsetWidth;
    var height = el.offsetHeight;

    force
    	.nodes(d3.values(nodes))
      .links(links)
      .size([width, height])
      .linkDistance(80)
      .charge(-100)
    	.linkStrength(0.2)
    	.friction(0.9)
    	.gravity(0.1)
    	.alpha(0.01)
      .on("tick", tick)
      .start();

    var link = d3.select(el).select("svg").selectAll(".link")
      .data(force.links())
      .enter()
    	.append("line")
      .attr("class", "link")
    	.attr("stroke-width", function(d) { return 10*d.weight; })
      .attr("stroke-opacity", .4)
      .attr("stroke", "#666");

    var node = d3.select(el).select("svg").selectAll(".node")
        .data(force.nodes())
        .enter().append("g")
        .attr("class", "node")
        .on("mouseover", mouseover)
        .on("mouseout", mouseout)
        .call(force.drag);

    node.append("circle")
      .attr("r", function(d) { return d.size; })
    	.attr("fill", function(d) { return d.color; })
      .attr('fill-opacity', options.circleFillOpacity)
      .attr("stroke", options.circleStroke)
      .attr("stroke-width", options.circleStrokeWidth);

    node.append("text")
    	.attr("class", "label")
      .attr("x", 12)
      .attr("dy", ".35em")
      .attr("font", "10px sans-serif")
      .attr("pointer-events", "none")
      .text(function(d) { return d.name; });

    node.append("text")
    	.attr("class", "full-label")
      .attr("x", 12)
      .attr("dy", ".35em")
      .attr("font", "10px sans-serif")
      .attr("pointer-events", "none")
    	.attr("display", "none")
    	.text(function(d) { return d.label; })

    function tick() {
      link
          .attr("x1", function(d) { return d.source.x; })
          .attr("y1", function(d) { return d.source.y; })
          .attr("x2", function(d) { return d.target.x; })
          .attr("y2", function(d) { return d.target.y; });

      node
          .attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; });
    }

    function mouseover() {
      d3.select(this).select("circle").transition()
        .duration(750)
        .attr("r", function(d) { return d.size*1.4; })
    	  .attr("fill", function(d) { return d3.rgb(d.color).brighter().toString(); });

      d3.select(this).select(".label")
    	  .attr("display", "none");

      d3.select(this).select(".full-label")
    	  .attr("display", "block");
    }

    function mouseout() {
      d3.select(this).select("circle").transition()
        .duration(750)
        .attr("r", function(d) { return d.size; })
    	  .attr("fill", function(d) { return d.color; });

      d3.select(this).select(".label")
    	  .attr("display", "block");

      d3.select(this).select(".full-label")
    	  .attr("display", "none");
    }

  }

});
