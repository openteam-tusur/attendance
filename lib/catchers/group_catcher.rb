require 'open-uri'

class GroupCatcher
  def sync
    mark_groups_deleted

    import groups

    delete_marked_groups
  end

  private

  def import(groups)
    groups.each do |group_number|
      Group.find_or_initialize_by(:number => group_number).tap do |g|
        g.deleted_at = nil
        g.save
      end
    end
  end

  def groups
    JSON.parse(open("#{Settings['timetable.url']}/attendance/groups.json").read)
  end

  def mark_groups_deleted
    Group.actual.update_all(:deleted_at => Time.zone.now)
  end

  def delete_marked_groups
    Group.not_actual.destroy_all
  end
end
