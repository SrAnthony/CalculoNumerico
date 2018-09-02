metodo_cordas = ->
  cordas_segment = $('div[data-method="cordas"]')
  $('button#metodo_cordas').on 'click', ->
    cordas_segment.addClass('loading')
    point_a = $('#function_point_a_cordas').val().split(',')[0]
    point_b = $('#function_point_b_cordas').val().split(',')[0]
    eps = $('#function_eps_cordas').val()
    round_value = $('#function_round_cordas').val()

    $.ajax
      url: "#{window.location.href}/metodo_cordas?eps=#{eps}&round_value=#{round_value}&point_a=#{point_a}&point_b=#{point_b}",
      success: (results) ->
        $('#cordas_result_area').fadeIn()
        $('#cordas_time').html results.time_spent
        $('#cordas_iterations').html results.result_values.length

        tbody = $('#cordas_tbody')
        tbody.html('')
        $.each results.result_values, (index, result) ->
          tbody.append "
          <tr class='center aligned'>
          <td><strong>#{result.iteration}</strong></td>
          <td>#{result.a}</td>
          <td>#{result.b}</td>
          <td>#{result.c}</td>
          <td>#{result.func_c}</td>
          </tr>"
        cordas_segment.removeClass('loading')

$(document).on 'turbolinks:load', metodo_cordas
