namespace :dev do
  PASSWORD_DEFAULT = 123456
  DEFAULT_FILES_PATH = File.join(Rails.root, 'lib', 'tmp')

  desc "Defining the default development settings"
  task setup: :environment do
    if Rails.env.development?
      show_spinner('Deleting Data Base...') {%x(rails db:drop:_unsafe)}
      show_spinner('Creating Data Base...') {%x(rails db:create)}
      show_spinner('Creating tables...') {%x(rails db:migrate)}
      show_spinner('Adding default admin...') {%x(rails dev:add_default_admin)}
      show_spinner('Adding extra admins...') {%x(rails dev:add_extra_admin)}
      show_spinner('Adding default user...') {%x(rails dev:add_default_user)}
      show_spinner('Adding subjects...') {%x(rails dev:add_subjects)}
      show_spinner('Adding questions and answers...') {%x(rails dev:add_questions_and_answers)}
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

  desc "Adding subjects"
  task add_subjects: :environment do
      file_name = 'subjects.txt'
      file_path = File.join(DEFAULT_FILES_PATH, file_name)

      File.open(file_path, 'r').each do |line|
      Subject.create!(description: line.strip)
    end
  end

  desc "Adding questions with answers"
  task add_questions_and_answers: :environment do
    Subject.all.each do |subject|
      rand(1..3).times do |i|
        params = { question: {
          description: "#{Faker::Lorem.paragraph} ??",
          subject: subject,
          answers_attributes: []
        }}

        rand(2..4).times do |j|
          params[:question][:answers_attributes] << { description: Faker::Lorem.sentence, correct: false }
        end
        
        params[:question][:answers_attributes].sample[:correct] = { description: Faker::Lorem.sentence, correct: true }
        Question.create!(params[:question])
      end
    end
  end

  desc "Reset the subject counter"
  task reset_subject_counter: :environment do
      Subject.all.each do |subject|
        Subject.reset_counters(subject.id, :questions)
      end
  end


  private
  def show_spinner(msg)
    spinner = TTY::Spinner.new(":spinner #{msg}", format: :pong)
    spinner.auto_spin
    yield
    spinner.success('(sucesso !!)')
  end
end
