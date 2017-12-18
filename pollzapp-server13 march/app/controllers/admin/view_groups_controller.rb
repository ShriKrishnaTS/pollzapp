class Admin::ViewGroupsController < ApplicationController
	
	


	
  def index
  end

  def groups_admin
  	@groups = Group.all

  end




end