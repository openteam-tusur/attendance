$ ->
  $('.ajaxed').on 'ajax:success', (evt, response) ->
    target = $(evt.target)

    target.closest('li').replaceWith(response) if target.hasClass('js-delete')
