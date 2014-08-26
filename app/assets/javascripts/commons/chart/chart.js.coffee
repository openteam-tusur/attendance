class Chart
  constructor: (id, @data) ->
    @id = "##{id}"
    @render()

  defaultOptions =
    chart:
      zoomType: 'x'

    xAxis:
      labels:
        style:
          fontSize: '12px'

    yAxis:
      min: 0
      max: 100

      labels:
        formatter: ->
          this.value+'%'

        style:
          fontSize: '12px'

      title:
        text: null

    title:
      text: null

    credits:
      enabled: false

    legend:
      borderWidth: 0

    tooltip:
      formatter: ->
        res = ""
        if this.point.x > 100000
          res += '<b>'+Highcharts.dateFormat('%e %b %Y', this.point.x)+'</b><br/>'
        else
          res += '<b>'+this.key+'</b><br/>'
        res += 'Посещаемость: '+this.point.y+'%'
        res

      style:
        fontSize: '12px'

  render: ->
    $ =>
      $(@id).highcharts $.extend(true, {}, defaultOptions, @options)

class @LineChart extends Chart
  constructor: (id, data) ->
    formatted_data = []

    for k,v of data
      formatted_data.push [Date.parse(k), v]

    @options =
      chart:
        type: 'spline'

      xAxis:
        type: 'datetime'

      series: [{
        showInLegend: false
        data: formatted_data
      }]

    super(id, data)

class @BarChart extends Chart
  constructor: (id, data) ->
    @options =
      chart:
        type: 'bar'

      xAxis:
        categories: []

      series: [{
        showInLegend: false
        data: data
      }]

    super(id, data)
