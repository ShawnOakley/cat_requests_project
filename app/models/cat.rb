class Cat < ActiveRecord::Base
  attr_accessible :age, :birth_date, :color, :name, :sex, :user_id

  validates :age, :birth_date, :color, :name, :sex, :user_id, presence: true

  validates_numericality_of :age
  validates_inclusion_of :sex, in: %w( M F )
  validates_inclusion_of :color, in: %w( Black Brown White Tabby Tie-Dye )

  has_many(
    :requests,
    class_name: "CatRentalRequest",
    foreign_key: :cat_id,
    primary_key: :id,
    dependent: :destroy
    )

    belongs_to(
    :owner,
    class_name: "User",
    foreign_key: :user_id,
    primary_key: :id,
    dependent: :destroy
    )

end
