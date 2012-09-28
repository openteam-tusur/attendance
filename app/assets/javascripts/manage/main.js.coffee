$ ->
  init_ajaxed() if $('.ajaxed').length
  init_presence_handler() if $('.edit_link').length
  init_calendar()  if $('.calendar_wrapper').length
  #init_counter()   if $('table.faculty, table.group').length
  init_check_wide() if $('.wide').length
