class HomeController < ApplicationController
  def index
    if user_signed_in?
      redirect_to :edit_user_registration
    else
      redirect_to :new_user_registration
    end
  end
end
