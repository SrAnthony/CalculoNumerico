load_chart = =>
  $.ajax
    url: "#{window.location.href}/evaluate_expression",
    success: (result) ->
      data = {
        type: 'line',
        plot: {
          aspect: 'spline'
        },
        'scale-y': {
          zooming: 1,
          refValue: 0,
          refLine: {
            visible: true,
            lineWidth: 2,
            lineColor: "#33994a"
          },
          guide: {
            "line-style": "dashdot"
          }
        },
        'scale-x': {
          zooming: 1,
          labels: result.expression_xs,
          refValue: 0,
          refLine: {
            visible: true,
            lineWidth: 2,
            lineColor: "#33994a"
          },
          markers: [
            {
              type: 'area',
              backgroundColor: '#d7e6f4',
              range: [result.position_a[0], result.position_b[0]],
              valueRange: true
            }
          ]
        },
        "crosshair-x": {
          "plot-label": {
            "text": "%t: %v",
            "background-color": "white",
            "border-width": 1,
            "border-color": "gray",
            "border-radius": "5px",
            "multiple": true
          }
        },
        series: [
          { values: result.expression_ys, 'guide-label': { text: 'f(x) = %v' } },
          { values: [result.position_a], marker: { type: 'diamond' }, text: 'Ponto A' },
          { values: [result.position_b], marker: { type: 'diamond' }, text: 'Ponto B' }
        ]
      }

      zingchart.render
        id: 'show_function_chart',
        data: data,
        output: 'canvas'

      # Evita o erro de aparecer por um tempo a tela de erro enquanto faz a transição de fadeout
      $('#chart_loading .errored.hidden').remove()
      # Esconde a div de loading (depois de 100 milissegundos pq sim)
      setTimeout ->
        $('#chart_loading').fadeOut()
      , 100

    error: ->
      # Em caso de erro, mostra mensagem depois de 1 segundo
      setTimeout ->
        $('#chart_loading .loader').hide()
        $('#chart_loading .errored').removeClass 'hidden'
      , 1000

$(document).on 'turbolinks:load', load_chart
