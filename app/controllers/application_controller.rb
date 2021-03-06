class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  private

  	# Confirms logged-in user
  	def logged_in_user
  		unless logged_in?
  			store_location
  			flash[:danger] = "Please log in"
  			redirect_to login_url
  		end
  	end

    # Confirms correct club is logged in
    def correct_club
      if @club = current_club
        redirect_to(root_url) unless current_club?(@club) || current_club.admin?
      else
        redirect_to(root_url)
      end
    end

end
