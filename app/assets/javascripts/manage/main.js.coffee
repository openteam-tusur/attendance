$ ->
  init_ajaxed() if $('.ajaxed').length
  init_presence_handler() if $('.edit_link').length
  init_calendar()  if $('.calendar_wrapper').length
