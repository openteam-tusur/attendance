check_faculty = () ->
  table = $('table.faculty')
  thead = table.children('thead')
  tbody = table.children('tbody')
  faculty_total = {
    faculty_aafsb: 0
    faculty_aaflwb: 0
  }

  courses = tbody.children('.course')
  courses.each ->
    course_total = {
      course_aafsb: 0
      course_aaflwb: 0
    }

    course_wrapper = $(this)
    groups = course_wrapper.nextUntil('.course')

    groups.each ->
      course_total.course_aaflwb += parseFloat($(this).children('.group_aaflwb').text())/groups.length
      course_total.course_aafsb  += parseFloat($(this).children('.group_aafsb').text())/groups.length

    faculty_total.faculty_aaflwb += course_total.course_aaflwb
    faculty_total.faculty_aafsb  += course_total.course_aafsb

    course_wrapper.children('.course_aaflwb').text(course_total.course_aaflwb.toFixed(1)+'%')
    course_wrapper.children('.course_aafsb').text(course_total.course_aafsb.toFixed(1)+'%')

  thead.find('.faculty_aaflwb').text((faculty_total.faculty_aaflwb/courses.length).toFixed(1)+'%')
  thead.find('.faculty_aafsb').text((faculty_total.faculty_aafsb/courses.length).toFixed(1)+'%')

chec_group = () ->
  table = $('table.group tbody tr')
  students = table.children('.student')
  students.each ->
    student = $(this)
    lesson_aaflwb = student.nextAll('.lesson_aaflwb').children('.percent')
    lesson_aafsb  = student.nextAll('.lesson_aafsb').children('.percent')
    total_aaflwb = 0
    total_aafsb  = 0
    lesson_aaflwb.each ->
      total_aaflwb += parseFloat($(this).text())/lesson_aaflwb.length
    lesson_aafsb.each ->
      total_aafsb  += parseFloat($(this).text())/lesson_aafsb.length
    student.children('.student_aaflwb').text(total_aaflwb.toFixed(1)+'%')
    student.children('.student_aafsb').text(total_aafsb.toFixed(1)+'%')

@init_counter = () ->
  check_faculty() if $('table.faculty').length
  chec_group()    if $('table.group').length
