# spec/api/api_bad_token_request.rb

require 'rails_helper'

describe Api::V1::RunsController do
  describe "POST a run without token" do
    it "should be 401 unauthorized" do
      run = Run.create
      post '/api/v1/runs'
      json = JSON.parse(response.body)
      print response.body
      expect(response).to be_unauthorized
      # expect(assigns(:teams)).to eq([team])
    end

    # it "renders the index template" do
    #   get :index
    #   expect(response).to render_template("index")
    # end
  end
end
