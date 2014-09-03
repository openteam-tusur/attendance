$ ->
  $('.users_autocomplete').autocomplete
    source: '/users/search'
    minLength: 2
    select: (event, ui) ->
      $('#permission_user_id').val(ui.item.id)
      return false
