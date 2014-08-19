$ ->
  btn = $('.js-date-range')
  date_filter = $('.date-range', '.tabs')

  handle_date_range = ->
    $('.active', '.tabs').removeClass('active')
    btn.addClass('active')
    date_filter.toggleClass('hidden')

  handle_date_range() if $('.js-date-range').hasClass('active')

  btn.on 'click', ->
    handle_date_range()

    date_filter.addClass('animated bounceInLeft')
