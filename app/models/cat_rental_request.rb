class CatRentalRequest < ActiveRecord::Base
  STATUSES= [
    "PENDING",
    "APPROVED",
    "DENIED"
  ]

  validates :cat_id, :start_date, :end_date, :status, :user_id, presence: true
  validates :status, inclusion: STATUSES
  validate :overlapping_approved_requests

  after_initialize { status ||= "PENDING" }

  belongs_to :cat
  belongs_to :user

  def pending?
    status == 'PENDING'
  end

  def approve!
    CatRentalRequest.transaction do
      self.status = "APPROVED"
      self.save
      self.overlapping_pending_requests.each do |request|
        request.deny!
      end
    end
  end

  def deny!
    self.status = "DENIED"
    self.save!
  end


    def overlapping_pending_requests
      overlapping_requests.select { |request| request.pending? }
    end

    def overlapping_requests
      data = CatRentalRequest.find_by_sql([<<-SQL, id: id, cat_id: cat_id, start_date: start_date, end_date: end_date])
        SELECT
          *
        FROM
          cat_rental_requests
        WHERE
          (cat_rental_requests.id <> :id OR :id IS NULL) AND
          cat_id = :cat_id AND
          (
            :start_date <= end_date AND start_date <= :end_date
          )
      SQL
      p data
      data
    end

    def overlapping_approved_requests
      if overlapping_requests.any? { |request| request.status == 'APPROVED' } && status == 'APPROVED'
        errors.add(:status, "Cannot overlap a request that has been approved")
      end
    end
end
