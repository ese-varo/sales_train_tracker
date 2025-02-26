module ApplicationHelper
  # Helper to check if a user can edit another user
  def can_edit_user?(user)
    return true if current_user.owner?
    return current_user.manager? && user.location_id == current_user.location_id && !user.manager?
  end
end
