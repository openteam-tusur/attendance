@init_documentation = ->
  $('h1').hide()
  $('<div>', { class: 'col-lg-3 col-md-3 col-sm-4 hidden-xs right-side', role: 'complementary' }).insertAfter($('#introduction').next('.left-side'))
  $('#introduction').nextAll().wrapAll($('<div>', { class: 'row landing_container' }))
  $('body').attr('data-spy': 'scroll', 'data-offset': '200').css( position: 'relative' )

  landing_container = $('.landing_container')

  affix_list = $('<ul>', { class: 'nav sidenav', role: 'tablist', width: $('.right-side', landing_container).width() }).appendTo($('.right-side', landing_container))

  #копируем ссылки из #introduction и копируем их в навигацию
  $('#introduction .subsection-navigation').each ->
    $('<div>', { html: $(this).clone(), class: "js-affix" }).appendTo(affix_list)
    return

  switch $('html').attr('lang')
    when 'en' then back_to_top_text = 'Back to top'
    when 'ru' then back_to_top_text = 'Наверх'

  back_to_top_link = $('<a>', { class: 'back-to-top', href: '#back-to-top', text: back_to_top_text })
  $('<li>', { html: back_to_top_link, class: 'not-hidden-li' }).appendTo(affix_list)

  init_affix = ->
    affix_offset_top = landing_container.position().top + 5
    affix_offset_bottom = $(document).height() - $('#content_wrapper').position().top - $('#content_wrapper').innerHeight() + 20
    affix_list.affix()
    affix_list.data('bs.affix').options.offset = { top: affix_offset_top, bottom: affix_offset_bottom }

    return

  setTimeout -> # fix wrong calculate offset after load page
    init_affix()
    return
  , 100

  $(window).scroll ->
    $('body').scrollspy('refresh')

  update_affix = ->
    $('.js-affix .subsection-navigation').each ->
      if $(this).find('.active').length < 1
        $(this).removeClass('navigation-active')
      else
        $(this).addClass('navigation-active')

  navigation_highlight_monkey_patch = ->
    $('.simple-navigation-active-leaf').each (index, item) ->
      $(item).addClass('active') unless $(item).hasClass('active')

  $(".js-affix").on 'activate.bs.scrollspy', ->
    update_affix()
    navigation_highlight_monkey_patch()

  $(window).resize ->
    init_affix()
    $(window).trigger('scroll')
    return

  $(window).scroll ->
    if $('.nav.sidenav').hasClass('affix-top') && $(window).scrollTop() < landing_container.position().top
      if $('.js-affix .subsection-navigation').hasClass('navigation-active')
        $('.js-affix .subsection-navigation').removeClass('navigation-active')
      return
    else
      unless $('.js-affix .subsection-navigation').hasClass('navigation-active')
        $('.js-affix .subsection-navigation:eq(0)').addClass('navigation-active')
      return
    return

  # monkeypatch for affix bug: https://github.com/twbs/bootstrap/issues/15847
  $(window).on 'keyup', (e) ->
    # safari fires 63273 instead of 36 for home key
    (e.keyCode == 36 || e.keyCode == 63273) && $(window).trigger('scroll')
    # safari fires 63275 instead of 35 for end key
    (e.keyCode == 35 || e.keyCode == 63275) && $(window).trigger('scroll')
    return

  $('#introduction a, .landing_container .nav a').click (event) ->
    hash = $(this).attr('href')
    target = $(hash)
    if hash == '#back-to-top'
      hash = ' '
      target = $('html')
    yScroll = document.body.scrollTop
    window.location.hash = hash
    document.body.scrollTop = yScroll
    $.scrollTo(target, 1000, { offset: { top: 0 } })
    return false

  return

$(document).ready ->
  if $('.documentation').length
    init_documentation()

