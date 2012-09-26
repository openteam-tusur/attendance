check_filled = () ->
  if $('.ajaxed').find('.was, .wasnt').length
    $('.days_wrapper li.active').removeClass('warning')

@init_ajaxed = () ->
  $('table').on 'ajax:success', (evt, response, status, jqXHR) ->
    target = $(evt.target)
    wrapper = target.closest('td')
    wrapper.html(jqXHR.responseText)
    init_switcher(wrapper)
    check_filled()
