$ ->
  # Statistic filters

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

  # Disruptions filters

  filter_btn  = $('.js-btn-filter')
  input_dates = $('#filter_dates')
  form        = $('.disruptions-form')

  filter_btn.on 'click', ->
    param = $(this).data('filter')

    input_dates.val(param)
    form.submit()

  $('.js-drop-filter').on 'click', ->
    $(':input', form).not(':button, :submit, :reset, :hidden').val('')

  handle_select_current = ->
    return unless form.length

    if $('#filter_name').val().length || $('#filter_faculty').val().length || $('#filter_approved').val().length
      form.toggleClass('hidden')
      btn.addClass('active')

  handle_select_current()
