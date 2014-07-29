require 'open-uri'

class StructureCatcher
  def sync
    mark_faculties_deleted
    mark_subdivisions_deleted

    import structure

    #delete_marked_faculties
    #delete_marked_subdivisions
  end

  private

  def import(structure)
    structure.each do |f|
      subdepartments = f.delete('subdepartments')
      faculty = import_faculty f

      subdepartments.each do |s|
        import_subdepartment faculty, s
      end
    end
  end

  def import_faculty(faculty)
    Faculty.find_or_initialize_by(faculty).tap do |f|
      f.deleted_at = nil
      f.save
    end
  end

  def import_subdepartment(faculty, subdepartment)
    faculty.subdepartments.find_or_initialize_by(subdepartment).tap do |s|
      s.deleted_at = nil
      s.save
    end
  end

  def structure
    JSON.parse(open(Settings['structure.url']).read)
  end

  def mark_faculties_deleted
    Faculty.actual.update_all(:deleted_at => Time.zone.now)
  end

  def mark_subdivisions_deleted
    Subdepartment.actual.update_all(:deleted_at => Time.zone.now)
  end

  def delete_marked_faculties
    Faculty.not_actual.destroy_all
  end

  def delete_marked_subdivisions
    Subdepartment.not_actual.destroy_all
  end
end
