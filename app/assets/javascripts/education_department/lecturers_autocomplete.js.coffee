$ ->
  $('.lecturers_autocomplete').autocomplete
    source: '/education_department/lecturers'
    minLength: 2
    select: (event, ui) ->
      $('#miss_missing_id').val(ui.item.id)
      return false
