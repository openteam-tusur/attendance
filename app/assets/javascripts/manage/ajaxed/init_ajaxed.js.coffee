check_filled = () ->
  if $('.ajaxed').find('.not_marked').length < 1
    $('.days_wrapper li.active').removeClass('warning')

@init_ajaxed = () ->
  $('table')
    .on 'ajax:success', (evt, response, status, jqXHR) ->
      target = $(evt.target)
      wrapper = target.closest('td, th')
      wrapper.html(jqXHR.responseText)
      init_switcher(wrapper) unless $('.simple_style', wrapper).length
      check_filled() unless wrapper.find('form').length > 0

      $.ajax({
        headers: {'Accept': 'application/json'}
      })
        .success (data, textStatus, jqXHR) ->
          if $.parseJSON(jqXHR.responseText).filled
            $('.days_wrapper .active').removeClass('warning')
          else
            $('.days_wrapper .active').addClass('warning')

      if target.hasClass('lesson_state')
        lesson_id = 'lesson_'+target.attr('href').match(/(\d+)\/switch_state/)[1]
        $('#'+lesson_id).toggle()

        $('a.'+lesson_id).each ->
          parent = $(this).closest('td')
          url = $(this).attr('href').replace(/\/edit/, '')
          $.ajax({
            url: url
          }).success (data, textStatus, jqXHR) ->
            parent.html(jqXHR.responseText)



