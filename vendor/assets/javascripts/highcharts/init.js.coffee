Highcharts.setOptions
  chart:
    zoomType: 'x'

  lang:
    downloadJPEG: 'Скачать JPEG',
    downloadPDF:  'Скачать PDF',
    downloadPNG:  'Скачать PNG',
    downloadSVG:  'Скачать SVG',
    exportButtonTitle: 'Экспорт',
    loading: 'Загрузка...',
    months: ['Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь', 'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь'],
    numericSymbols: [],
    printButtonTitle: 'Печать',
    printChart: 'Напечатать график',
    rangeSelectorFrom: 'С',
    rangeSelectorTo: 'По',
    rangeSelectorZoom: 'Период',
    resetZoom: 'Сбросить',
    resetZoomTitle: 'Сбросить приближение',
    shortMonths: ['Янв', 'Фев', 'Март', 'Апр', 'Май', 'Июнь', 'Июль', 'Авг', 'Сент', 'Окт', 'Нояб', 'Дек'],
    weekdays: ['Воскресенье', 'Понедельник', 'Вторник', 'Среда', 'Четверг', 'Пятница', 'Суббота'],

  tooltip:
    formatter: ->
      res = ""
      if this.point.x > 100000
        res += '<b>'+Highcharts.dateFormat('%e %b %Y', this.point.x)+'</b><br/>'
      else
        res += '<b>'+this.key+'</b><br/>'
      res += 'Посещаемость: '+this.point.y+'%'
      res

  yAxis:
    max: 100
    labels:
      formatter: ->
        this.value+'%'
