class Calendar
  constructor: (target) ->
    target[0].object = @
    @months = []
    @top   = 0
    @source_element = target
    @prepare_months()
    @prepare_handlers()
    @set_current_visible()

  prepare_months: ->
    for month in $('.month', @source_element)
      @months.push(new Month(@, month))

  prepare_handlers: ->
    @source_element.closest('.calendar-viewport').siblings('.js-scroll').on 'click', (evt) =>
      $target = $(evt.target)
      @next() if $target.hasClass('scroll-down')
      @prev() if $target.hasClass('scroll-up')
      @set_height()

  set_height: ->
    @source_element.parent().css
      height: @_visible_months().reduce (x,y) ->
        x.height + y.height
      , 0

  set_current_visible: ->
    @source_element.css('top', @top -= @current_month_offset())
    @set_height()

  current_month: ->
    return m for m in @months when m.current

  current_month_offset: ->
    cur_month = @current_month()
    return unless cur_month.prev()
    cur_month.source_element.position().top - cur_month.prev().height

  _visible_months: ->
    res = []

    for m in @months
      res.push m if m.visible()

    res

  next: ->
    return if Math.abs(@top) == @source_element.outerHeight(true) - @source_element.parent().outerHeight(true)
    @source_element.animate({'top': @top -= @_visible_months()[0].height})

  prev: ->
    return if Math.round(@top) == 0
    @source_element.animate
      'top': @top += @_visible_months()[0].prev().height

class Month
  @_count = 0

  @count: ->
    @_count

  constructor: (calendar, target) ->
    target.object = @
    @calendar = calendar
    @source_element = $(target)
    @id       = ++Month._count
    @height   = @source_element.outerHeight(true)
    @current  = @source_element.hasClass('current')

  visible: ->
    top_position = Math.round(@source_element.position().top + @calendar.top)
    if @prev()
      top_position == @prev().height #|| top_position == 0
    else
      top_position == 0

  prev: ->
    @calendar.months[@id-2]

  next: ->
    @calendar.months[@id]

$ ->
  new Calendar($('.calendar')) if $('.calendar').length
