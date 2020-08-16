class Question < ApplicationRecord
  belongs_to :subject, inverse_of: :questions
  has_many :answers
  accepts_nested_attributes_for :answers, reject_if: :all_blank, allow_destroy: true


  scope :_search_, ->(term, page) { 
    Question.includes(:answers).where("lower(description) LIKE ?", "%#{term.downcase}%").page(page).per(7) 
  }

  scope :last_questions, ->(page) { 
    Question.includes(:answers).order('created_at desc').page(page).per(3) 
  }  
end
