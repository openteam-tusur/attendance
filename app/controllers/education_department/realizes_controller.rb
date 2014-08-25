class EducationDepartment::RealizesController < AuthController
  inherit_resources
  load_and_authorize_resource
  custom_actions :resource => [:accept, :refuse, :change]

  def accept
    accept!{
      change_approved(:yes)

      redirect_to education_department_disruptions_path and return
    }
  end

  def refuse
    refuse!{
      change_approved(:no)

      redirect_to education_department_disruptions_path and return
    }
  end

  def change
    change!{
      change_approved(nil)

      redirect_to education_department_disruptions_path and return
    }
  end

  private

  def change_approved(desicion)
    @realize.approved = desicion
    @realize.save
  end
end
