var DayNames = ["Dilluns", "Dimarts", "Dimecres", "Dijous", "Divendres", "Dissabte", "Diumenge"];

var stackedAvailability = function(container, data){
  data = data.reverse();
  var width = 940;
  var height = 100;
  var padding = 20;
  var labelMargin = 5;
  var barWidth = (width / data.length);
  var hourOfTheDay = d3.time.format("%H:%M");

  var max = d3.max(data.map(function(sample){ return sample.used + sample.unused }));

  var x = d3.scale.linear().domain([0, data.length]).range([0, width]);
  var y = d3.scale.linear().domain([0, max]).rangeRound([0, height]);

  var viewport = d3.select(container)
      .append("svg:svg")
      .attr("width", width)
      .attr("height", height + (padding * 2));

  var chart = viewport.append("svg:g").attr("transform", "translate(0," + padding + ")");

  chart.selectAll("rect.parking")
      .data(data)
      .enter().append("svg:rect")
      .attr("x", function(d, i){ return x(i) })
      .attr("y", function(sample, i){ return height - (y(sample.unused) + y(sample.used)) })
      .attr("fill", "#eee")
      .attr("stroke", "white")
      .attr("shape-rendering", "crispEdges")
      .attr("width", barWidth)
      .attr("height", function(sample){ return y(sample.unused) });

  chart.selectAll("rect.bycycles")
      .data(data)
      .enter().append("svg:rect")
      .attr("x", function(sample, index){ return x(index) })
      .attr("y", function(sample){ return height - y(sample.used) })
      .attr("fill", "steelblue")
      .attr("shape-rendering", "crispEdges")
      .attr("stroke", "white")
      .attr("width", barWidth)
      .attr("height", function(sample){ return y(sample.used) });

  chart.selectAll("text.hour")
      .data(data)
      .enter().append("svg:text")
      .attr("font-family", "sans-serif")
      .attr("font-size", 10)
      .attr("font-weight", "bold")
      .attr("fill", "#444")
      .attr("text-anchor", "middle")
      .attr("dominant-baseline", "text-before-edge")
      .text(function(sample){ return hourOfTheDay(new Date(0, 0, 0, sample.hour)) })
      .attr("x", function(sample, index){ return x(index) + (barWidth / 2) })
      .attr("y", height + labelMargin);

  chart.selectAll("text.value")
      .data(data)
      .enter().append("svg:text")
      .attr("font-family", "sans-serif")
      .attr("font-size", 10)
      .attr("fill", "#ccc")
      .attr("text-anchor", "middle")
      .text(function(sample){ return sample.used + "/" + sample.unused })
      .attr("x", function(sample, index){ return x(index) + (barWidth / 2) })
      .attr("y", function(sample){
        return d3.min([
          height - (y(sample.unused) + y(sample.used)),
          height - y(sample.used)
        ]) - labelMargin
      });
}

var usageDistribution = function(container, criteria, data){
  var horizontalPadding = 70;
  var verticalPadding = 30;

  var width = 940;
  var maxCircleSize = (width / 2 / 25);
  var height = (maxCircleSize * 2 * 8);

  var chartWidth = width - horizontalPadding;
  var chartHeight = height - verticalPadding;

  var labelMargin = 10;
  var maxUsed = d3.max(data, function(sample){ return sample[criteria] });
  var y = d3.scale.linear().domain([-1, 7]).range([0, chartHeight]);
  var x = d3.scale.linear().domain([-1, 24]).range([0, chartWidth]);
  var z = d3.scale.linear().domain([0, maxUsed]).range([0, maxCircleSize]);
  var color = d3.scale.linear().domain([0, maxUsed]).interpolate(d3.interpolateRgb).range(["#eee", "steelblue"])

  var dayOfTheWeek = d3.time.format("%a");
  var hourOfTheDay = d3.time.format("%H:%M");

  var viewport = d3.select(container)
      .append("svg:svg")
      .attr("width", width)
      .attr("height", height);

  var chart = viewport.append("svg:g")
      .attr("transform", "translate(" + horizontalPadding + ", 0)");

  chart.selectAll("line.y")
      .data(d3.range(0, 7))
      .enter().append("svg:line")
      .attr("x1", 0)
      .attr("x2", chartWidth)
      .attr("y1", y)
      .attr("y2", y)
      .attr("shape-rendering", "crispEdges")
      .attr("stroke", "#eee");

  chart.selectAll("line.x")
      .data(d3.range(0, 24))
      .enter().append("svg:line")
      .attr("x1", x)
      .attr("x2", x)
      .attr("y1", 0)
      .attr("y2", chartHeight)
      .attr("shape-rendering", "crispEdges")
      .attr("stroke", "#eee");

  chart.selectAll("circle.value")
      .data(data)
      .enter()
      .append("svg:circle")
      .attr("stroke", "none")
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
      .attr("y", chartHeight + labelMargin)
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
      .text(function(day){ return DayNames[day] });

  chart.append("svg:rect")
      .attr("x", 0)
      .attr("y", 1)
      .attr("width", chartWidth - 1)
      .attr("height", chartHeight - 1)
      .attr("fill", "none")
      .attr("stroke", "black")
      .attr("shape-rendering", "crispEdges");
}