metodo_bisseccao = ->
  bisseccao_segment = $('div[data-method="bisseccao"]')
  $('button#metodo_bisseccao').on 'click', ->
    bisseccao_segment.addClass('loading')
    point_a = $('#function_point_a_bisseccao').val().split(',')[0]
    point_b = $('#function_point_b_bisseccao').val().split(',')[0]
    eps = $('#function_eps_bisseccao').val()

    $.ajax
      url: "#{window.location.href}/metodo_bisseccao?eps=#{eps}&point_a=#{point_a}&point_b=#{point_b}",
      success: (results) ->
        $('#bisseccao_result_area').fadeIn()
        tbody = $('#bissecao_tbody')
        $.each results.result_values, (index, result) ->
          tbody.append "
          <tr class='center aligned'>
          <td><strong>#{result.iteration}</strong></td>
          <td>#{result.a}</td>
          <td>#{result.b}</td>
          <td>#{result.c}</td>
          <td>#{result.func_c}</td>
          </tr>"
        bisseccao_segment.removeClass('loading')

$(document).on 'turbolinks:load', metodo_bisseccao
