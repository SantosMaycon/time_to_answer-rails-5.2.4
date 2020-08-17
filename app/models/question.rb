class Question < ApplicationRecord
  belongs_to :subject, inverse_of: :questions
  has_many :answers
  accepts_nested_attributes_for :answers, reject_if: :all_blank, allow_destroy: true

  scope :_search_subject_, ->(page, subject_id){
    includes(:answers, :subject).where(subject_id: subject_id).page(page)
  }

  scope :_search_, ->(term, page) { 
    includes(:answers, :subject).where("lower(description) LIKE ?", "%#{term.downcase}%").page(page).per(7) 
  }

  scope :last_questions, ->(page) { 
    includes(:answers, :subject).order('created_at desc').page(page).per(10) 
  }  
end
