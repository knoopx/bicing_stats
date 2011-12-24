var stackedAvailability = function(container, used, unused){
  var w = 700;
  var h = 100;

  var max = d3.max([d3.max(used), d3.max(unused)]);
  var x = d3.scale.linear().domain([0, used.length]).range([0, w]);
  var y = d3.scale.linear().domain([0, max]).rangeRound([0, h]);

  var chart = d3.select(container)
      .append("svg:svg")
      .attr("width", w)
      .attr("height", h);

  chart.selectAll("rect.bycycles")
      .data(used)
      .enter().append("svg:rect")
      .attr("x", function(d, i){ return x(i) })
      .attr("y", function(d){ return h - y(d) })
      .attr("fill", "steelblue")
      .attr("fill-opacity", 0.5)
      .attr("stroke", "white")
      .attr("width", function(d){ return w / used.length})
      .attr("height", function(d){ return y(d) });

  chart.selectAll("rect.parking")
      .data(unused)
      .enter().append("svg:rect")
      .attr("x", function(d, i){ return x(i) })
      .attr("y", function(d, i){ return h - y(d) - y(used[i]) })
      .attr("fill", "#ccc")
      .attr("fill-opacity", 0.5)
      .attr("stroke", "white")
      .attr("width", function(d){ return w / used.length})
      .attr("height", function(d){ return y(d) });
}

var usageDistribution = function(container, criteria, data){
  var padding = 50;
  var maxCircleSize = 18;
  var width = (maxCircleSize * 2 * 25);
  var height = (maxCircleSize * 2 * 8);
  var labelMargin = 10;
  var maxUsed = d3.max(data, function(sample){ return sample[criteria] });
  var y = d3.scale.linear().domain([-1, 7]).range([0, height]);
  var x = d3.scale.linear().domain([-1, 24]).range([0, width]);
  var z = d3.scale.linear().domain([0, maxUsed]).range([0, maxCircleSize]);
  var color = d3.scale.linear().domain([0, maxUsed]).interpolate(d3.interpolateRgb).range(["#ccc", "#A2C0D9"])

  var dayOfTheWeek = d3.time.format("%a");
  var hourOfTheDay = d3.time.format("%H:%M");

  var viewport = d3.select(container)
      .append("svg:svg")
      .attr("width", width + (padding * 2))
      .attr("height", height + (padding * 2))

  var chart = viewport.append("svg:g")
      .attr("transform", "translate(" + padding + "," + padding + ")");

  chart.selectAll("line.y")
      .data(d3.range(0, 7))
      .enter().append("svg:line")
      .attr("x1", 0)
      .attr("x2", width)
      .attr("y1", y)
      .attr("y2", y)
      .attr("stroke", "#eee");

  chart.selectAll("line.x")
      .data(d3.range(0, 24))
      .enter().append("svg:line")
      .attr("x1", x)
      .attr("x2", x)
      .attr("y1", 0)
      .attr("y2", height)
      .attr("stroke", "#eee");

  chart.selectAll("circle.value")
      .data(data)
      .enter()
      .append("svg:circle")
      .attr("fill", function(sample){ return color(sample[criteria])})
      .attr("cx", function(sample){ return x(sample.hour) })
      .attr("cy", function(sample){ return y(sample.day) })
      .attr("r", function(sample){ return z(sample[criteria]) });

  chart.selectAll("text.value")
      .data(data.filter(function(sample){ return z(sample[criteria]) > 5 }))// render only labels greater than 5px
      .enter().append("svg:text")
      .attr("class", "value")
      .attr("fill", "white")
      .attr("font-family", "sans-serif")
      .attr("font-size", function(sample){ return z(sample[criteria]) })
      .attr("text-anchor", "middle")
      .attr("dominant-baseline", "central")
      .attr("x", function(sample){ return x(sample.hour) })
      .attr("y", function(sample){ return y(sample.day) })
      .text(function(sample){ return sample[criteria] });

  chart.selectAll("text.label-x")
      .data(d3.range(0, 24))
      .enter().append("svg:text")
      .attr("x", x)
      .attr("y", height + labelMargin)
      .attr("text-anchor", "middle")
      .attr("dominant-baseline", "text-before-edge")
      .attr("font-family", "sans-serif")
      .attr("font-size", 10)
      .text(function(hour){ return hourOfTheDay(new Date(0, 0, 0, hour))});

  chart.selectAll("text.label-y")
      .data(d3.range(0, 7))
      .enter()
      .append("svg:text")
      .attr("text-anchor", "end")
      .attr("dominant-baseline", "central")
      .attr("font-family", "sans-serif")
      .attr("font-size", 10)
      .attr("x", -labelMargin)
      .attr("y", y)
      .text(function(day){ return dayOfTheWeek(new Date(0, 0, day + 1))});

  chart.append("svg:rect")
      .attr("x", 0)
      .attr("width", width)
      .attr("y", 0)
      .attr("height", height)
      .attr("fill", "none")
      .attr("stroke", "black");
}