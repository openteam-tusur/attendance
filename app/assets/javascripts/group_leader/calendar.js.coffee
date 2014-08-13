class Calendar
  constructor: (target) ->
    target[0].object = @
    @months = []
    @source_element = target
    @prepare_months()
    @prepare_handlers()
    @top   = 0

  prepare_months: ->
    for month in @source_element.find('.month')
      @months.push(new Month(@, month))

  prepare_handlers: ->
    @source_element.closest('.calendar-viewport').siblings('.js-scroll').on 'click', (evt) =>
      $target = $(evt.target)
      @next() if $target.hasClass('scroll-down')
      @prev() if $target.hasClass('scroll-up')
      @source_element.parent().css('height', @_visible_months().reduce (x,y) -> x.height + y.height)

  _visible_months: ->
    res = []

    for m in @months
      res.push m if m.visible()

    res

  next: ->
    return if Math.abs(@top) == @source_element.outerHeight(true) - @source_element.parent().outerHeight(true)
    @source_element.css('top', @top -= @_visible_months()[0].height)

  prev: ->
    return if @top == 0
    @source_element.css('top', @top += @_visible_months()[0].prev().height)

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
    if @prev()
      @source_element.position().top + @calendar.top == @prev().height || @source_element.position().top + @calendar.top == 0
    else
      @source_element.position().top + @calendar.top == 0

  prev: ->
    @calendar.months[@id-2]

  next: ->
    @calendar.months[@id]

$ ->
  new Calendar($('.calendar'))
