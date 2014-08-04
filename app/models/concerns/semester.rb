module Semester
  extend ActiveSupport::Concern

  module ClassMethods
    def semester_starts_at
      month = Date.today.month

      if month > 8
        Date.new(Date.today.year, 9, 1)
      else
        Date.new(Date.today.year, 1, 1)
      end
    end
  end
end
