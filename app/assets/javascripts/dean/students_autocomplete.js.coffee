$ ->
  $('.absent_autocomplete').autocomplete
    source: '/dean/students'
    minLength: 2
    select: (event, ui) ->
      $('#miss_missing_id').val(ui.item.id)
      return false
