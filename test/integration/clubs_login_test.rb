require 'test_helper'

class ClubsLoginTest < ActionDispatch::IntegrationTest

	def setup
		@club = clubs(:michael)
	end
  
	test "login with invalid information" do 
		get login_path
		assert_template 'sessions/new'
		post login_path, params: { session: { email: "", password: "" } }
		assert_template 'sessions/new'
		assert_not flash.empty?
		get root_path
		assert flash.empty?
	end

	test "login with valid information followed by logout" do
		get login_path
		post login_path, params: { session: { email: @club.email,
											  password: 'password' } }
		assert is_logged_in?
		assert_redirected_to @club
		follow_redirect!
		assert_template 'clubs/show'
		assert_select "a[href=?]", login_path, count: 0
		assert_select "a[href=?]", logout_path
		assert_select "a[href=?]", club_path(@club)
		delete logout_path
		assert_not is_logged_in?
		assert_redirected_to root_url
		follow_redirect!
		assert_select "a[href=?]", login_path
		assert_select "a[href=?]", logout_path, count: 0
		assert_select "a[href=?]", club_path(@club), count: 0
	end

end
