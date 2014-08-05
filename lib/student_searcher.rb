class StudentSearcher < Struct.new(:params)
  def search
    Sunspot.search Student do |q|
      q.with(:info, params[:q])
      q.with(:deleted_at, nil)
    end
  end
end
