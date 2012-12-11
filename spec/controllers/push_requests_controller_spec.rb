require 'spec_helper'

describe PushRequestsController do

  describe "GET 'make_push'" do
    it "returns http success" do
      get 'make_push'
      response.should be_success
    end
  end

  describe "GET 'query'" do
    it "returns http success" do
      get 'query'
      response.should be_success
    end
  end

end
