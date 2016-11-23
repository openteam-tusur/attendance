$ ->

  return unless $('.calendar').length

  wrapper = $('.calendar-viewport')
  calendar = $('.calendar', wrapper)
  months = $('.month', calendar)
  link_up = wrapper.siblings('.scroll-up')
  link_down = wrapper.siblings('.scroll-down')

  if months.length <= 2
    init_height = months.get().sum (item) ->
      $(item).outerHeight()
    link_up.addClass('disabled')
    link_down.addClass('disabled')
  else
    init_height = months.get().last(2).sum (item) ->
      $(item).addClass('visible').outerHeight()

  wrapper.height(init_height)

  link_up.click ->
    return if $(this).hasClass('disabled')
    $('.visible:first', calendar).prev().addClass('visible')
    $('.visible:last', calendar).removeClass('visible')
    $(this).addClass('disabled') if months.first().hasClass('visible')
    link_down.removeClass('disabled')
    slide_and_resize('-')

  link_down.click ->
    return if $(this).hasClass('disabled')
    $('.visible:last', calendar).next().addClass('visible')
    $('.visible:first', calendar).removeClass('visible')
    $(this).addClass('disabled') if months.last().hasClass('visible')
    link_up.removeClass('disabled')
    slide_and_resize('+')

  slide_and_resize = (direction) ->
    speed = 300
    height = $('.visible', calendar).get().sum (item) ->
      $(item).outerHeight()
    wrapper.animate
      height: height
    , speed
    offset = 0
    offset = $('.visible:last', calendar).next().outerHeight() if direction == '-'
    offset = $('.visible:first', calendar).prev().outerHeight() if direction == '+'
    console.log "#{direction}=#{offset}"
    calendar.animate
      bottom: "#{direction}=#{offset}"
    , speed
    return

  return
