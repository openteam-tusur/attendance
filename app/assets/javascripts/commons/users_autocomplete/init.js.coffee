$ ->
  $('.users_autocomplete').autocomplete
    source: (request, response) ->
      $.ajax
        url: '/users/search'
        data:
          term: request.term
        success: (data) ->
          response(data)
        error: (data) ->
          window.location = '/' if data.status == 500
    minLength: 2
    select: (event, ui) ->
      $('#permission_user_id').val(ui.item.id)
      $('.users_autocomplete').val(ui.item.label)
      return false
