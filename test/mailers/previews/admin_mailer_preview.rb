class AdminMailerPreview < ActionMailer::Preview
  def update_email
    AdminMailer.with(Admin.first, Admin.last).update_email
	end
end
   