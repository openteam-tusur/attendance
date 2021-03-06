require 'open-uri'
require 'catchers/rest_responser'
include RestResponser

class StudentCatcher
  def wrong
    {
      'Кафедра теоритических основ радиотехники' => 'Кафедра телекоммуникаций и основ радиотехники',
      'Кафедра конструирования узлов и деталей РЭС' => 'Кафедра конструирования узлов и деталей радиоэлектронной аппаратуры',
      'Кафедра ЭМИС' => 'Кафедра экономической математики, информатики и статистики',
      'Кафедра электронных приборов и устройст' => 'Кафедра электронных приборов',
      'Кафедра философии и социологии' => 'Кафедра Философии и социологии',
      'Кафедра безопасности информационных систем' => 'кафедра безопасности информационных систем',
      'Кафедра менеджмента' => 'кафедра менеджмента',
    }
  end

  def wrong_groups
    {
      '213' => '213-1',
      '223' => '223-1',
      '471' => '471-1'
    }
  end

  def sync
    mark_students_deleted

    import

    #delete_marked_students
  end

  private

  def import
    redo_counter = 0

    Group.actual.find_each do |group|
      next if group.number =~ /\d{6}-\d/
      students_info = students_of group.number

      if students_info[:code] != 200
        if redo_counter > 10
          abort("StudentCatcher: students.openteam.ru вернул код ошибки #{students_info[:code]} более 10 раз.
          Синхронизация принудительно остановлена")
        end

        redo_counter += 1
        sleep 15
        redo
      end
      puts group.number
      students = students_info[:json]

      if students.empty?
        students = students_of(wrong_groups[group.number])[:json]
      end
      students += students_of("#{group.number}_")[:json]
      next if students.empty?

      update_group group, students.first['group']
      import_students students, group
    end
  end

  def students_of(group_number)
    # JSON.parse(open(URI.encode("#{Settings['students.url']}/api/v1/students?group=#{group_number}")).read)
    RestResponser.rest_response URI.encode("#{Settings['students.url']}/api/v1/students?group=#{group_number}")
  end

  def import_students(students, group)
    students.each do |student|
      Student.find_or_initialize_by(contingent_id: student['study_id']).tap do |s|
        s.surname    = student['lastname']
        s.name       = student['firstname']
        s.patronymic = student['patronymic']
        s.deleted_at = nil
        s.save
        s.memberships.where(participate: group).update_all(deleted_at: nil)
        s.groups << group unless s.groups.include?(group)
        s.index
      end
    end
  end

  def update_group(group, group_info)
    group.course = group_info['course']

    begin
      group.subdepartment = Subdepartment.find_by!(title: (wrong[group_info['subfaculty']['name']] || group_info['subfaculty']['name']))
    rescue ActiveRecord::RecordNotFound
      raise group_info['subfaculty']['name'].to_s
    end

    group.save
  end

  def mark_students_deleted
    Student.actual.update_all(deleted_at: Time.zone.now)
    Membership.actual.students.update_all(deleted_at: Time.zone.now)
  end

  def delete_marked_students
    Student.not_actual.destroy_all
  end
end
