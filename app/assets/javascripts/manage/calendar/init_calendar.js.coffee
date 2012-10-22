$.fn.calculate_visible = () ->
  wrapper = $(this)
  current_offset = wrapper.position().left
  li_count = wrapper.children('li').length
  li_width = wrapper.children('li:first').outerWidth(true, true)

  controls = wrapper.closest('.days_wrapper').siblings('.controls')
  total_width = li_count * li_width
  wrapper.css
    width: total_width

  if current_offset >= 0
    controls.children('.prev').addClass('disabled')
  else
    controls.children('.prev').removeClass('disabled')
  if total_width + current_offset <= li_width * 6
    controls.children('.next').addClass('disabled')
  else
    controls.children('.next').removeClass('disabled')
  return this

@init_calendar = () ->
  line_wrapper = $('.calendar_wrapper .days_wrapper ul')
  li_width = line_wrapper.children('li:first').outerWidth(true, true)
  active = line_wrapper.children('.active')

  if active.prevAll().length > 5
    line_wrapper.css
      left: - (active.prevAll().length - 5) * li_width
  else
    line_wrapper.css
      left: 0

  line_wrapper.calculate_visible()

  $('.calendar_wrapper .controls a').click (evt) ->
    control = $(evt.target)
    current_left = line_wrapper.position().left

    return false if control.hasClass('proccessing') || line_wrapper.children('li').length < 7 || control.hasClass('disabled')
    control.addClass('proccessing')

    if control.hasClass('next')
      line_wrapper.animate(
        {'left': current_left-li_width*6},
        duration: 'slow'
        complete: ->
          control.removeClass('proccessing')
          line_wrapper.calculate_visible()
      )

    if control.hasClass('prev')
      line_wrapper.animate(
        {'left': current_left+li_width*6},
        duration: 'slow'
        complete: ->
          control.removeClass('proccessing')
          line_wrapper.calculate_visible()
      )

    false
