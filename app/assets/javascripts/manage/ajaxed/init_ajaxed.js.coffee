@init_ajaxed = () ->
  $('table').on 'ajax:success', (evt, response, status, jqXHR) ->
    target = $(evt.target)
    wrapper = target.closest('td')
    wrapper.html(jqXHR.responseText)
    init_switcher(wrapper)
