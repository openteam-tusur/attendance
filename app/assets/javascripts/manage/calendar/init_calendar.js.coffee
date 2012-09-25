$.fn.calculate_visible = () ->
  wrapper = $(this)
  current_offset = wrapper.position().left
  li_count = wrapper.children('li').length
  controls = wrapper.closest('.days_wrapper').siblings('.controls')
  total_width = li_count * 153

  if current_offset == 0
    controls.children('.prev').addClass('disabled')
  else
    controls.children('.prev').removeClass('disabled')

  if total_width + current_offset == 918
    controls.children('.next').addClass('disabled')
  else
    controls.children('.next').removeClass('disabled')

@init_calendar = () ->
  line_wrapper = $('.calendar_wrapper .days_wrapper ul')
  line_wrapper.calculate_visible()

  active = line_wrapper.children('.active')

  if active.prevAll().length > 4
    line_wrapper.css('left', 918 - (active.position().left+active.outerWidth()))
  else
    line_wrapper.css('left', 0)

  $('.calendar_wrapper .controls a').on 'click', (evt) ->
    control = $(evt.target)
    current_left = line_wrapper.position().left

    return false if control.hasClass('proccessing') || line_wrapper.children('li').length < 7 || control.hasClass('disabled')
    control.addClass('proccessing')


    if control.hasClass('next')
      line_wrapper.animate(
        {'left': current_left-153},
        complete: ->
          control.removeClass('proccessing')
          line_wrapper.calculate_visible()
      )

    if control.hasClass('prev')
      line_wrapper.animate(
        {'left': current_left+153},
        complete: ->
          control.removeClass('proccessing')
          line_wrapper.calculate_visible()
      )

    false
