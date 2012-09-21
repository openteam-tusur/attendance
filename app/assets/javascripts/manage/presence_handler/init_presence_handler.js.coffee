cancel_handler = () ->
  $('.cancel_link').on 'click', (evt) ->
    link = $(evt.target)
    prev = link.prev('.edit_link').text('редактировать').removeClass('clicked')
    target_class = prev.attr('id')
    $('.'+target_class).next('.cancel_presence').click()
    link.remove()

    false

@init_presence_handler = () ->
  $('.edit_link').on 'click', (evt) ->
    link = $(evt.target)
    target_class = link.attr('id')

    link.toggleClass('clicked')

    if link.hasClass('clicked')
      link.text('сохранить')
      $('<a href="#" class="cancel_link">отмена</a>').insertAfter(link)
      cancel_handler()
    else
      link.text('редактировать')
      link.next('a').remove()

    $('.'+target_class).click()

    false
