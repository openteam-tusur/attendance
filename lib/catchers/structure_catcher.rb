require 'open-uri'

class StructureCatcher
  def sync
    remember_state_before_sync
    mark_faculties_deleted
    mark_subdivisions_deleted
    @sync_results = { new_faculties: [], new_subdepartments: [] }

    import structure



    make_report
    #delete_marked_faculties
    #delete_marked_subdivisions
  end

  private

  def import(structure)
    structure.each do |f|
      faculty_hash = {
        title: f['title'],
      }
      subdepartments = f.delete('chairs')
      faculty = import_faculty faculty_hash


      subdepartments.each_with_index do |s,i|
        subdepartment_hash = {
          abbr: s['abbr'],
          title: s['title']
        }
        import_subdepartment faculty, subdepartment_hash
      end
    end
  end

  def import_faculty(faculty)
    Faculty.find_or_initialize_by(faculty).tap do |f|
      @sync_results[:new_faculties] << f if f.new_record?
      f.deleted_at = nil
      f.save
    end
  end

  def import_subdepartment(faculty, subdepartment)
    faculty.subdepartments.find_or_initialize_by(subdepartment).tap do |s|
      @sync_results[:new_subdepartments] << s if s.new_record?
      s.deleted_at = nil
      s.save
    end
  end

  def structure
    JSON.parse(open("#{Settings['directory.url']}/api/structure").read)
  end

  def mark_faculties_deleted
    Faculty.actual.update_all(deleted_at: Time.zone.now)
  end

  def mark_subdivisions_deleted
    Subdepartment.actual.update_all(deleted_at: Time.zone.now)
  end

  def delete_marked_faculties
    Faculty.not_actual.destroy_all
  end

  def delete_marked_subdivisions
    Subdepartment.not_actual.destroy_all
  end

  def remember_state_before_sync
    @faculties_before = Faculty.actual.pluck(:id)
    @subdepartments_before = Subdepartment.actual.pluck(:id)
  end

  def make_report
    lost_faculties = @faculties_before - Faculty.actual.pluck(:id)
    lost_subdepartments = @subdepartments_before - Subdepartment.actual.pluck(:id)

    report = ''.tap do |r|
      r << "\nУдалены факультеты: #{ lost_faculties.map{ |id| Faculty.find(id).title }.join(', ')}." if lost_faculties.any?
      r << "\nУдалены кафедры: #{ lost_subdepartments.map{ |id| Subdepartment.find(id).title }.join(', ')}." if lost_subdepartments.any?
      r << "\nДобавлены факультеты: #{ @sync_results[:new_faculties].map(&:title).join(", ") }." if @sync_results[:new_faculties].any?
      r << "\nДобавлены кафедры: #{ @sync_results[:new_subdepartments].map(&:title).join(", ")}" if @sync_results[:new_subdepartments].any?
    end

    report.length > 0 ? "Структура факультетов и кафедр изменилась: #{ report }" : "Структура не изменилась"
  end

end
