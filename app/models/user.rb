# == Schema Information
#
# Table name: users
#
#  id                     :bigint(8)        not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  name                   :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  invitation_token       :string
#  invitation_created_at  :datetime
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_type        :string
#  invited_by_id          :bigint(8)
#  invitations_count      :integer          default(0)
#  team_id                :bigint(8)
#  role                   :integer
#

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_and_belongs_to_many :teams
  belongs_to :match, optional: true
  has_many :activities, dependent: :destroy
  has_many :activity_statuses
  has_many :feedback, dependent: :destroy
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :validatable, validate_on_invite: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  enum role: %i[user judge admin]
  scope :all_except_actual, ->(actual_user) { where.not(id: actual_user).order('email ASC') }

  after_invitation_accepted :initialize_user

  def current_team
    teams&.find_by(match: Match.last)
  end

  def normal_user?
    user?
  end

  def part_of_team?(team_slug)
    teams&.find_by(slug: team_slug) ? true : false
  end

  def project
    current_team&.project
  end

  def can_be_invited?
    !User.find_by_email(email)&.current_team
  end

  def initialize_user
    update_attributes!(role: User.roles[:user])
    teams << invited_by&.current_team
  end
end
