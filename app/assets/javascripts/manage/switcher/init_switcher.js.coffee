@init_switcher = (context) ->
  switcher = $('div.radio_buttons', context).append('<span class="thumb"></span>')
  if switcher.find('#presence_kind_was').is(':checked')
    switcher.toggleClass('on')

  switcher.on 'click', (evt) ->
    current_swithcer = $(evt.target).closest('.radio_buttons').toggleClass('on')
    if current_swithcer.hasClass('on')
      current_swithcer.find('#presence_kind_was').attr('checked', 'checked')
    else
      current_swithcer.find('#presence_kind_wasnt').attr('checked', 'checked')
    false
