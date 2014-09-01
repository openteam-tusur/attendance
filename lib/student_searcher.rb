class StudentSearcher < Struct.new(:params)
  def search
    Sunspot.search Student do |q|
      q.with(:info, params[:q])
      q.with(:deleted_at, nil)
    end
  end

  def autocomplete_search
    Sunspot.search Student do |q|
      q.with(:info).starting_with(params[:term])
      q.with(:faculty_id, params[:faculty_id])
      q.with(:deleted_at, nil)
    end
  end
end
