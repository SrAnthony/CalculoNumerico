metodo_newton = ->
  newton_segment = $('div[data-method="newton"]')
  $('button#metodo_newton').on 'click', ->
    newton_segment.addClass('loading')
    point_a = $('#function_point_a_newton').val().split(',')[0]
    point_b = $('#function_point_b_newton').val().split(',')[0]
    derivative_1 = $('#function_derivative_1_newton').val()
    derivative_2 = $('#function_derivative_2_newton').val()
    eps = $('#function_eps_newton').val()

    $.ajax
      url: "#{window.location.href}/metodo_newton?derivative1=#{derivative_1}&derivative2=#{derivative_2}&point_a=#{point_a}&point_b=#{point_b}&eps=#{eps}",
      success: (results) ->
        $('#newton_result_area').fadeIn()
        $('#newton_time').html results.time_spent
        $('#newton_iterations').html results.result_values.length

        tbody = $('#newton_tbody')
        tbody.html('')
        $.each results.result_values, (index, result) ->
          tbody.append "
          <tr class='center aligned'>
          <td><strong>#{result.iteration}</strong></td>
          <td>#{result.a}</td>
          <td>#{result.func_a}</td>
          <td>#{result.func_der_a}</td>
          <td>#{result.xn}</td>
          <td>#{result.result}</td>
          </tr>"
        newton_segment.removeClass('loading')

$(document).on 'turbolinks:load', metodo_newton
