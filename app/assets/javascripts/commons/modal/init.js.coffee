$ ->
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

  # Удаление объяснительной
  $('.ajaxed').on 'ajax:success', (evt, response, status, jqXHR) ->
    target = $(evt.target)

    if target.hasClass('js-delete')
      $('.lesson').html(response)

      init_popover()

  # Показываем модальное окно при добавлении и редактировании объяснительной
  $('.ajaxed').on 'click', '.js-modal', ->
    url = $(this).attr("href")

    $.get(url, (data) ->
      $(data).modal()
      return
    ).then handle_validation

    false

  # Удаляем модальное окно при закрытии
  $("body").on "hidden.bs.modal", ".modal", ->
    $(this).removeData "bs.modal"
    $(this).remove()
    return
