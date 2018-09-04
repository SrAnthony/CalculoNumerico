metodo_bisseccao = ->
  bisseccao_segment = $('div[data-method="bisseccao"]')
  $('button#metodo_bisseccao').on 'click', ->
    bisseccao_segment.addClass('loading')
    point_a = $('#function_point_a_bisseccao').val().split(',')[0]
    point_b = $('#function_point_b_bisseccao').val().split(',')[0]
    eps = $('#function_eps_bisseccao').val()
    round_value = $('#function_round_bisseccao').val()

    $.ajax
      url: "#{window.location.href}/metodo_bisseccao?round_value=#{round_value}&eps=#{eps}&point_a=#{point_a}&point_b=#{point_b}",
      success: (results) ->
        $('#bisseccao_result_area').fadeIn()
        $('#bisseccao_time').html results.time_spent
        $('#bisseccao_iterations').html results.result_values.length

        tbody = $('#bisseccao_tbody')
        tbody.html('')
        $.each results.result_values, (index, result) ->
          tbody.append "
          <tr class='center aligned'>
          <td><strong>#{result.iteration}</strong></td>
          <td>#{result.a}</td>
          <td>#{result.func_c}</td>
          </tr>"
        bisseccao_segment.removeClass('loading')

$(document).on 'turbolinks:load', metodo_bisseccao
