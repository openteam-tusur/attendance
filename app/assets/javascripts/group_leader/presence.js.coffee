$ ->
  $('.presence_cell').on 'ajax:success', (evt, response) ->
    $(evt.target).parent().html(response)
