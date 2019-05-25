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

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user_with_team = users(:user_with_team)
    @user_no_team = users(:user)
  end

  test 'user must be invalid without email' do
    user = User.new(password: 'normalUser',
                    password_confirmation: 'normalUser')
    refute user.valid?
  end

  test 'user can be valid if email is not from michelada domain' do
    user = User.new(email: 'miguel.urbina@gmail.com',
                    password: 'normalUser',
                    password_confirmation: 'normalUser')
    assert user.valid?
  end

  test 'user must be valid' do
    user = User.new(email: 'miguel.urbina@michelada.io',
                    password: 'normalUser',
                    password_confirmation: 'normalUser')
    assert user.valid?
  end

  test 'user must be a normal user' do
    assert @user_with_team.normal_user?
    assert @user_no_team.normal_user?
  end

  test 'user must be a judge user' do
    user = users(:judge_user)
    assert user.judge?
  end

  test 'user must be an admin user' do
    user = users(:admin_user)
    assert user.admin?
  end

  test 'user has no a team' do
    refute @user_no_team.current_team
  end

  test 'user must have a team' do
    assert @user_with_team.current_team
  end

  test 'user must be part of a the team' do
    team = teams(:team3)
    assert @user_with_team.part_of_team?(team.slug)
  end

  test 'user with team can not be invited' do
    user = users(:user_with_team)
    refute user.can_be_invited?
  end

  test 'user with no team can be invited to one' do
    assert @user_no_team.can_be_invited?
  end

  test 'user that is not already registered in system can be invited' do
    user = User.new(email: 'miguel.urbina@michelada.io',
                    password: 'normalUser',
                    password_confirmation: 'normalUser')
    assert user.can_be_invited?
  end

  test 'user should not have a team' do
    refute @user_no_team.current_team
  end

  test 'user should be part of a team' do
    assert @user_with_team.current_team
  end

  test 'user can obtain its current team' do
    team = teams(:team_project_match)
    assert_equal team, @user_with_team.current_team
  end

  test 'user current team is related to the last match version' do
    assert_equal Match.last, @user_with_team.current_team.match
  end

  test 'user with no last-match team should not have a current team' do
    @user_with_team.teams.last.destroy
    refute @user_with_team.current_team
  end
end
