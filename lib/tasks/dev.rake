namespace :dev do
  PASSWORD_DEFAULT = 123456

  desc "Defining the default development settings"
  task setup: :environment do
    if Rails.env.development?
      show_spinner('Deleting Data Base...') {%x(rails db:drop:_unsafe)}
      show_spinner('Creating Data Base...') {%x(rails db:create)}
      show_spinner('Creating tables...') {%x(rails db:migrate)}
      show_spinner('Adding default admin...') {%x(rails dev:add_default_admin)}
      show_spinner('Adding extra admins...') {%x(rails dev:add_extra_admin)}
      show_spinner('Adding default user...') {%x(rails dev:add_default_user)}
    else
      puts 'You must be in the development environment to use the task!'
    end
  end

  desc "Adding default administrator"
  task add_default_admin: :environment do
    Admin.create!(
      email: "admin@admin.com", 
      password: PASSWORD_DEFAULT, 
      password_confirmation: PASSWORD_DEFAULT
    )
  end

  desc "Adding extra administrator"
  task add_extra_admin: :environment do
    10.times do |i|
      Admin.create!(
        email: Faker::Internet.email, 
        password: PASSWORD_DEFAULT, 
        password_confirmation: PASSWORD_DEFAULT
      )
    end
  end

  desc "Adding default user"
  task add_default_user: :environment do
    User.create!(
      email: "user@user.com", 
      password: PASSWORD_DEFAULT, 
      password_confirmation: PASSWORD_DEFAULT
    )
  end

  private
  def show_spinner(msg)
    spinner = TTY::Spinner.new(":spinner #{msg}", format: :pong)
    spinner.auto_spin
    yield
    spinner.success('(sucesso !!)')
  end
end
