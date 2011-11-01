@usageDistribution = (data, width, height) ->
  dayNames = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
  x = pv.Scale.linear(0, 24).range(0, width)
  y = pv.Scale.linear(7, 1).range(0, height)
  zmax = pv.max(data, (sample) -> sample.used)

  z = pv.Scale.linear(0, zmax).range(0, 400)
  x.tickFormat = (val) -> val + ":00"
  y.tickFormat = (val) -> dayNames[val - 1]

  vis = new pv.Panel().width(width).height(height).strokeStyle("#eee").bottom(30).left(30).right(30).top(30)
  vis.add(pv.Rule).data(x.ticks(24)).left(x).strokeStyle("#eee").anchor("bottom").add(pv.Label).text x.tickFormat
  vis.add(pv.Rule).data(y.ticks(7)).bottom(y).strokeStyle("#eee").anchor("left").add(pv.Label).text y.tickFormat

  vis.add(pv.Dot)
    .data(data)
    .left((sample) -> x sample.hour)
    .bottom((sample) -> y sample.day)
    .size((sample) -> z sample.used)
    .fillStyle("rgba(30, 120, 180, .4)")
    .anchor("center")
    .add(pv.Label).text((sample) -> sample.used if sample.used > 0)

  vis.render()

@unusageDistribution = (data, width, height) ->
  dayNames = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
  x = pv.Scale.linear(0, 24).range(0, width)
  y = pv.Scale.linear(7, 1).range(0, height)
  zmax = pv.max(data, (sample) -> sample.unused)

  z = pv.Scale.linear(0, zmax).range(0, 400)
  x.tickFormat = (val) -> val + ":00"
  y.tickFormat = (val) -> dayNames[val - 1]

  vis = new pv.Panel().width(width).height(height).strokeStyle("#eee").bottom(30).left(30).right(30).top(30)
  vis.add(pv.Rule).data(x.ticks(24)).left(x).strokeStyle("#eee").anchor("bottom").add(pv.Label).text x.tickFormat
  vis.add(pv.Rule).data(y.ticks(7)).bottom(y).strokeStyle("#eee").anchor("left").add(pv.Label).text y.tickFormat

  vis.add(pv.Dot)
    .data(data)
    .left((sample) -> x sample.hour)
    .bottom((sample) -> y sample.day)
    .size((sample) -> z sample.unused)
    .fillStyle("rgba(30, 120, 180, .4)")
    .anchor("center")
    .add(pv.Label).text((sample) -> sample.unused if sample.unused > 0)

  vis.render()