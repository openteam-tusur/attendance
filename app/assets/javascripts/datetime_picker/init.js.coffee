$ ->
  $('input.datetime_picker').datetimepicker
    changeMonth: true
    changeYear: true
    addSliderAccess: false
    sliderAccessArgs:
      isRTL: false
      touchonly: false

  $('input.datepicker').datepicker
    changeMonth: false
    changeYear: false
