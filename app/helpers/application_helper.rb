module ApplicationHelper
  def admin_space?
    controller.class.name.split("::").first=="Admin"
  end
end
