class Admin::MainController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin!

  layout 'admin'

  private

  def authenticate_admin!
    # TODO: Enable this at some time.
    #redirect_to root_path , alert: 'Admin Area is restricted' unless current_user.has_role? :admin
  end


end
