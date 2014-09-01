class Unfilled < Struct.new(:group)

  def days
  end

  private

  def lessons
    group.lessons.actual.joins(:presences).unfilled
  end
end
