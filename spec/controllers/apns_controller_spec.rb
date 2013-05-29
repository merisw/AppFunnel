require 'spec_helper'

describe ApnsController do
  let(:user) { Factory(:confirmed_user) }
  let(:apn) { Factory(:apn) }

  context "applicants" do
    { :new => :get, create: :post, edit: :get, index: :get, show: :get,
     update: :put, destroy: :delete }.each do |action, method|
      it "cannot #{action} another's application" do
        sign_in(:user, user)
        send(method, action, id: apn.id)
        response.should redirect_to(root_path)
        flash[:alert].should eql("You need permission to do that.")
      end
    end
  end

end
