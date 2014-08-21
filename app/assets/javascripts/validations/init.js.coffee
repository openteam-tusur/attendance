$ ->
  textarea = $('.js-validation textarea')

  check_textarea = ->
    if textarea.val()
      enable_submit()
    else
      disable_submit()

  enable_submit = ->
    $('.js-submit').removeAttr('disabled').removeClass('disabled')

  disable_submit = ->
    $('.js-submit').attr('disabled', 'disabled').addClass('disabled')

  textarea.keyup ->
    check_textarea()

  check_textarea()
