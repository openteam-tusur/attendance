@init_popover = ->
  $('.js-popover').popover
    trigger: 'hover'

$ ->
  init_popover()
