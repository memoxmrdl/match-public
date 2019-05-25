require 'test_helper'
require 'pry'

class TeamInvitationControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:user_with_team)
    login_as @user
    @match = Match.last
  end

  test 'user can invite any user with any email' do
    user = users(:user_test1)
    post match_team_invitations_path(@match, user.current_team), params: {
      email: 'example_user@gmail.io'
    }

    assert_equal I18n.t('team.messages.user_invited'), flash[:notice]
  end

  test 'user can invite a new user' do
    post match_team_invitations_path(@match, @user.current_team), params: {
      email: 'miguel.urbina@michelada.io'
    }

    assert_equal I18n.t('team.messages.user_invited'), flash[:notice]
  end

  test 'user can invite a user with no team' do
    user = users(:user_test2)
    post match_team_invitations_path(@match, @user.current_team), params: {
      email: user.email
    }

    assert_equal flash[:notice], I18n.t('team.messages.user_invited')
  end

  test 'user can not invite if the team already have 3 members' do
    user = users(:user_test2)
    user.teams << @user.current_team

    post match_team_invitations_path(@match, @user.current_team), params: {
      email: 'miguel.urbina@michelada.io'
    }

    assert_equal I18n.t('team.messages.error_limit_members'), flash[:alert]
  end

  test 'user can not invite a user if he/she already has a team' do
    user = users(:user_test1)

    post match_team_invitations_path(@match, @user.current_team), params: {
      email: user.email
    }

    assert_equal flash[:alert], I18n.t('team.invalid_user')
  end
end
