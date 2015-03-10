class CatRentalRequest < ActiveRecord::Base
  STATUSES= [
    "PENDING",
    "APPROVED",
    "DENIED"
  ]

  validates :cat_id, :start_date, :end_date, :status, presence: true
  validates :status, inclusion: STATUSES
  validate :overlapping_approved_requests

  after_initialize { status ||= "PENDING" }

  belongs_to :cat

  private
    def overlapping_requests
      CatRentalRequest.find_by_sql([<<-SQL, id: id, cat_id: cat_id, start_date: start_date, end_date: end_date])
        SELECT
          *
        FROM
          cat_rental_requests
        WHERE
          (cat_rental_requests.id <> :id OR :id IS NULL) AND
          cat_id = :cat_id AND
          (
            (start_date BETWEEN :start_date AND :end_date) OR
            (end_date BETWEEN :start_date AND :end_date)
          )
      SQL
    end

    def overlapping_approved_requests
      if overlapping_requests.any? { |request| request.status == 'APPROVED' } && status == "APPROVED"
        errors.add(:status, "Cannot overlap a request that has been approved")
      end
    end
end
