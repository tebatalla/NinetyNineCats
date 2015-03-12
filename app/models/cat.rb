class Cat < ActiveRecord::Base
  SEX = ['M', 'F']

  COLORS = [
    'brown',
    'gray',
    'white',
    'black',
    'ginger',
    'tan'
  ]

  validates :color, :sex, :name, :birth_date, presence: true
  validates :sex, inclusion: SEX
  validates :color, inclusion: COLORS

  has_many :cat_rental_requests, dependent: :destroy

  belongs_to(
    :owner,
    foreign_key: :user_id,
    primary_key: :id,
    class_name: "User"
  )


  def age
    today = Date.today
    age = today.year - birth_date.year
    age -= 1 if birth_date.strftime("%m%d").to_i > today.strftime("%m%d").to_i
    age
  end

  def cat_attributes
    {
      "Name" => name,
      "Age" => age,
      "Color" => color,
      "Sex" => sex,
      "Description" => description
    }
  end
end
