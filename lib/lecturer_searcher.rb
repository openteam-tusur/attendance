class LecturerSearcher < Struct.new(:params)
  def autocomplete_search
    Sunspot.search Lecturer do |q|
      q.with(:info).starting_with(params[:term])
      q.with(:deleted_at, nil)
    end
  end
end
