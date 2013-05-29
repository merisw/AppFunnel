require 'spec_helper'

describe ProfilesController do
  let(:user) { Factory(:confirmed_user) }
  let(:profile) { Factory(:profile, user_id: user.id) }

  context "applicants" do
    { :new => :get }.each do |action, method|
      it "cannot #{action} another's profile" do
        sign_in(:user, user)
        send(method, action, id: profile.id)
        response.should redirect_to(root_path)
        flash[:alert].should eql("You need permission to do that.")
      end
    end
  end

end
