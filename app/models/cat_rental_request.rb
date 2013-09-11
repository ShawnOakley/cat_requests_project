class CatRentalRequest < ActiveRecord::Base
  attr_accessible :cat_id, :start_date, :end_date, :status

  before_validation do
    self.status ||= "PENDING"
  end

  validates :status, inclusion: { in: %w( PENDING APPROVED DENIED ) }
  validates :cat_id, :start_date, :end_date, :status, presence: true
  validates :cat_id, inclusion: { in: Cat.pluck(:id) }

  validate :no_overlapping_requests

  belongs_to(
  :cat,
  class_name: "Cat",
  foreign_key: :cat_id,
  primary_key: :id
  )

  def approve!
    self.status = "APPROVED"
    self.save!
    transaction do
      overlapping_requests("PENDING").each do |request|
        request.deny!
      end
    end
  end

  def deny!
    self.status = "DENIED"
    self.save!
  end

  def pending?
    self.status == "PENDING"
  end


  private

  def no_overlapping_requests
    requests = overlapping_requests("APPROVED")
    unless requests.empty? || self.status != "APPROVED"
      requests.each do |request|
        errors[:start_date] << "Conflicts with another start date"
        errors[:end_date] << "Conflicts with another end date"
      end
    end
  end

  def overlapping_requests(status)
    CatRentalRequest.where(cat_id: self.cat_id, status: status).
    where("start_date <= ? AND end_date >= ?", self.end_date, self.start_date).
    where("id != ?", self.id)
  end


end
