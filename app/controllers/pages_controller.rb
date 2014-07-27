class PagesController < ApplicationController

  def welcome
    if current_user.member?
      redirect_to controller: 'attachments', action: 'new' and return
    end
  end

  def about
  end

  def privacy
  end
end
