chart1 = =>
  data =  {
    type: 'line',
    plot:{
      aspect: 'spline'
    },
    'scale-y': {
      zooming: 1,
      refValue : 0,
      refLine : {
          visible: true,
          lineWidth: 2,
          lineColor: "#33994a"
      }
    },
    'scale-x': {
      zooming: 1,
      labels: gon.expression_x_values,
      # refValue e refLine são para formar a linha do x, y = 0
      refValue : gon.expression_values_range,
      refLine : {
          visible: true,
          lineWidth: 2,
          lineColor: "#33994a"
      }
    },
    series: [
      { values: gon.expression_y_values }
    ]
  }

  zingchart.render({
    id : 'show_function_chart',
    data : data,
    output: 'canvas'
  })

$(document).on 'turbolinks:load', chart1
