class Question < ApplicationRecord
  belongs_to :subject, counter_cache: true, inverse_of: :questions
  has_many :answers
  accepts_nested_attributes_for :answers, reject_if: :all_blank, allow_destroy: true

  after_create :set_statistic

  # Scopes
  scope :_search_subject_, ->(page, subject_id){
    includes(:answers, :subject).where(subject_id: subject_id).page(page)
  }

  scope :_search_, ->(term, page) { 
    includes(:answers, :subject).where("lower(description) LIKE ?", "%#{term.downcase}%").page(page).per(7) 
  }

  scope :last_questions, ->(page) { 
    includes(:answers, :subject).order('created_at desc').page(page).per(10) 
  }
  
  private

  def set_statistic
    AdminStatistic.set_event(AdminStatistic::EVENTS[:total_questions])
  end   
end
