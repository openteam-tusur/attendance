@init_check_wide = () ->
  wider_block_width = $('.wider_block').outerWidth()
  if wider_block_width > 980
    $('.content').css('width', wider_block_width)
    $('.main_wrapper').css('width', $('.content').outerWidth())
