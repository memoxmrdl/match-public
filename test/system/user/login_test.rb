require 'application_system_test_case'

class LoginTest < ApplicationSystemTestCase
  def setup
    Match.last.destroy
    @match = matches(:active_content_match)
  end

  test 'user can login with a valid account' do
    @user = users(:user)
    login_as @user
  end

  test 'the first view of the user is invite collabortors' do
    @user = users(:user)
    login_as @user

    visit new_match_team_path(@match)
    assert_equal(current_path, new_match_team_path(@match))
  end

  test 'if user forgot its password he/she can change it using Forget my password option' do
    visit new_user_session_path
    click_link I18n.t('user.forgot_password')
    assert_equal(current_path, new_user_password_path)

    fill_in 'user[email]', with: 'normal_user@michelada.io'
    click_button 'Enviar instrucciones'
    assert page.has_content?(I18n.t('devise.passwords.send_instructions'))
  end

  test 'users email is valid if it is part of @michelada domain' do
    visit new_user_registration_path

    fill_in 'user[email]', with: 'new_normal_user@michelada.io'
    fill_in 'user[password]', with: '123456'
    fill_in 'user[password_confirmation]', with: '123456'
    click_button 'Registrarse'

    assert page.has_content?('Bienvenido')
  end

  test 'any user email is valid' do
    visit new_user_registration_path

    fill_in 'user[email]', with: 'normal_user@gmail.com'
    fill_in 'user[password]', with: '123456'
    fill_in 'user[password_confirmation]', with: '123456'

    click_button 'Registrarse'
    assert page.has_content?('Debes crear primero tu equipo')
  end

  test 'user can logout' do
    @user = users(:user)
    login_as @user
    visit new_match_team_path(@match)
    click_link I18n.t('user.log_out')
    assert_equal(current_path, root_path)
    assert page.has_content?('Cerraste sesión correctamente.')
  end
end
