class PagesController < ApplicationController

  def welcome
    if current_user.member?
      redirect_to controller: 'uploads', action: 'new' and return
    end
  end

  def about
  end

  def privacy
  end
end
