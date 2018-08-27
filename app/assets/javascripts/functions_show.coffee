load_chart = =>
  $.ajax
    url: "#{window.location.href}/evaluate_expression",
    success: (result) ->
      series_point_a = {}
      series_point_b = {}
      range_marker = {}

      if result.has_point_a
        series_point_a = { values: [result.position_a], marker: { type: 'diamond' }, text: 'Ponto A' }
      if result.has_point_b
        series_point_b = { values: [result.position_b], marker: { type: 'diamond' }, text: 'Ponto B' }
      if result.has_point_a && result.has_point_b
        range_marker =
          type: 'area',
          backgroundColor: '#d7e6f4',
          range: [result.position_a[0], result.position_b[0]],
          valueRange: true

      data = {
        type: 'line',
        plot: {
          aspect: 'spline'
        },
        zoom: {
          label: {
            visible: true,
            'font-family': 'monospace'
          }
        },
        'scroll-x': {},
        'scroll-y': {},
        'scale-y': {
          zooming: true,
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
          zooming: true,
          labels: result.expression_xs,
          refValue: 0,
          refLine: {
            visible: true,
            lineWidth: 2,
            lineColor: "#33994a"
          },
          markers: [
            range_marker
          ]
        },
        'crosshair-x': {
          'plot-label': {
            text: "%t: %v",
            'background-color': 'white',
            'border-width': 1,
            'border-color': 'gray',
            'border-radius': '5px',
            'font-family': 'monospace',
            multiple: true
          }
        },
        labels: [
          {
            id: 'zoom-out-to-start',
            text: 'Resetar zoom',
            backgroundColor:'#E0E1E2',
            fontColor: 'rgba(0, 0, 0, 0.6)',
            fontWeight: 'bold',
            fontFamily: 'Raleway',
            fontSize: 15,
            x: '100%',
            y: 5,
            offsetX: -120,
            padding: 8,
            cursor: 'pointer',
            visible: false, # hide label by default
            flat: false, # makes label clickable
            borderRadius: 5,
            hoverState: {
              backgroundColor: '#CACBCD'
            }
          }
        ],
        series: [
          { values: result.expression_ys, 'guide-label': { text: 'f(x) = %v' } },
          # Só mostra cada ponto se esse existir
          series_point_a,
          series_point_b
        ]
      }

      # Binds para o botão de resetar o zoom
      zingchart.bind 'show_function_chart', 'label_click', (e) ->
        if e.labelid == 'zoom-out-to-start'
          zingchart.exec('show_function_chart', 'viewall')

      zingchart.bind 'show_function_chart', 'zoom', (e) ->
        if e.action && e.action == 'viewall'
          zingchart.exec 'show_function_chart', 'updateobject', {
            type: 'label',
            data: {
              id: 'zoom-out-to-start',
              visible: false
            }
          }
        else
          zingchart.exec 'show_function_chart', 'updateobject', {
            type: 'label',
            data: {
              id: 'zoom-out-to-start',
              visible: true
            }
          }
      # ==========================================

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
