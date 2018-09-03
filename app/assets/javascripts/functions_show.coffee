chart_reset_zoom_button = (chart_id) =>
  zingchart.bind chart_id, 'label_click', (e) ->
    if e.labelid == 'zoom-out-to-start'
      zingchart.exec(chart_id, 'viewall')

  zingchart.bind chart_id, 'zoom', (e) ->
    if e.action && e.action == 'viewall'
      zingchart.exec chart_id, 'updateobject', {
        type: 'label',
        data: {
          id: 'zoom-out-to-start',
          visible: false
        }
      }
    else
      zingchart.exec chart_id, 'updateobject', {
        type: 'label',
        data: {
          id: 'zoom-out-to-start',
          visible: true
        }
      }

chart_data = {}

load_chart = =>
  $.ajax
    url: "#{window.location.href}/evaluate_expression",
    success: (result) ->
      series_point_a = []
      series_point_b = []
      range_marker = {}

      if result.has_point_a
        series_point_a = [result.position_a]
      if result.has_point_b
        series_point_b = [result.position_b]
      if result.has_point_a && result.has_point_b
        range_marker =
          type: 'area',
          backgroundColor: '#d7e6f4',
          range: [result.position_a[0], result.position_b[0]],
          valueRange: true

      chart_data = {
        type: 'line',
        plot: {
          aspect: 'spline'
        },
        zoom: {
          label: {
            visible: true,
            'font-family': 'Fira Mono'
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
            'font-family': 'Fira Mono',
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
            fontFamily: 'Fira Mono',
            fontSize: 15,
            x: '100%',
            y: 5,
            offsetX: -150,
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
          { values: series_point_a, marker: { type: 'diamond' }, text: 'Ponto A' },
          { values: series_point_b, marker: { type: 'diamond' }, text: 'Ponto B' }
        ]
      }

      chart_reset_zoom_button('show_function_chart')

      zingchart.render
        id: 'show_function_chart',
        data: chart_data,
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

update_points = =>
  # Só executa o listener uma (one) vez. Não é preciso mais.
  $('#function_point_a, #function_point_b').one 'keydown', ->
    $('#update_points').removeClass 'hidden'

  $('#update_points').on 'click', ->
    point_a = $('#function_point_a').val()
    point_b = $('#function_point_b').val()

    # Atualiza inputs dos métodos
    $('#function_point_a_bisseccao')[0].value = point_a
    $('#function_point_b_bisseccao')[0].value = point_b
    $('#function_point_a_cordas')[0].value = point_a
    $('#function_point_b_cordas')[0].value = point_b
    $('#function_point_a_newton')[0].value = point_a
    # =====================================

    if point_a != "" && point_b != ""
      chart_data['scale-x'].markers = [
        {
          type: 'area',
          backgroundColor: '#d7e6f4',
          range: [parseInt(point_a.split(',')[0]), parseInt(point_b.split(',')[0])],
          valueRange: true
        }
      ]
      # Gráfico é re-renderizado com o novo marcador
      zingchart.render
        id: 'show_function_chart',
        data: chart_data,
        output: 'canvas'

    if point_a != ""
      point_a = point_a.split(',')
      zingchart.exec 'show_function_chart', 'setseriesvalues',
        plotindex : 1,
        values : [[parseInt(point_a[0]), parseInt(point_a[1])]]

    if point_b != ""
      point_b = point_b.split(',')
      zingchart.exec 'show_function_chart', 'setseriesvalues',
        plotindex : 2,
        values : [[parseInt(point_b[0]), parseInt(point_b[1])]]

default_derivative = =>
  der_input = $('#function_derivative_newton')
  expression = $('#expression_title').data 'expression'
  expression_der = math.derivative expression, 'x'
  der_input.val expression_der
  # Remove os espaços
  der_input.val der_input.val().replace(/\s/g, '')

$(document).on 'turbolinks:load', load_chart
$(document).on 'turbolinks:load', update_points
$(document).on 'turbolinks:load', default_derivative
