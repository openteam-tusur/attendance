$ ->
  $('.js-presence-cell').on 'ajax:success', (evt, response) ->
    $(evt.target).parent().html(response)
