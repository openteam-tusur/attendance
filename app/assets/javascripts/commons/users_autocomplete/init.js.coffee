$ ->
  $('.users_autocomplete').autocomplete
    source: '/users/search'
    minLength: 2
    select: (event, ui) ->
      $('#permission_user_id').val(ui.item.id)
      $('.users_autocomplete').val(ui.item.label)
      return false
