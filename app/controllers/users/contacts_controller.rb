class Users::ContactsController < ApplicationController
  before_action :authenticate_user!

  def new
  	@contact = Contact.new
  end

  def create
  	@contact = Contact.new(contact_params)
  	if @contact.save
  	  redirect_to action: :done
    else
      render 'new'
    end
  end

  def done
  end


  private
  def contact_params
  	params.require(:contact).permit(:user_id, :title, :content, :status)
  end
end
