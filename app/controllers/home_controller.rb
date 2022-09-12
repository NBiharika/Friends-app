class HomeController < ApplicationController
  def index
  end

  def about 
    @application = Doorkeeper::Application.find(name: 'Niharika Bhaskar')

    @application = {
      name: @application.name,
      client_id: @application.uid,
      client_secret: @application.secret,
    }
  end
  
end
