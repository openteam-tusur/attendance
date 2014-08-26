$ ->
  btn   = $('.js-modal')
  modal = $('.modal')

  # Валидация для textarea
  handle_validation = ->
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

  $('body').on 'ajax:success', (evt, response, status, jqXHR) ->
    target = $(evt.target)

    if target.hasClass('form-declaration')
      $('.modal').modal('toggle')

      $('.lesson').html(response)

    if target.hasClass('js-delete')
      $('.lesson').html(response)

    init_popover()


  $('body').on 'click', '.js-modal', ->
    url = $(this).attr("href")

    $.get(url, (data) ->
      $(data).modal()
      return
    ).success ->
      handle_validation()

    false

  # Удаляем модальное окно при закрытии
  $("body").on "hidden.bs.modal", ".modal", ->
    $(this).removeData "bs.modal"
    $(this).remove()
    return
