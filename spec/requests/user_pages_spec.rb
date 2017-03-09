#require 'rails_helper'

#RSpec.describe "UserPages", type: :request do
#  describe "GET /user_pages" do
#    it "works! (now write some real specs)" do
#      get user_pages_index_path
#      expect(response).to have_http_status(200)
#    end
#  end
#end

require 'spec_helper'

describe "User pages" do
	subject { page}
	describe "profile page" do
		let(:user) { FactoryGirl.create(:user) }
		before { visit user_path(user) }
		it { should have_content(user.name) }
		it { should have_title(user.name) }
	end
	describe "signup page" do
		before { visit '/signup'}
		it { should have_content('Sign up')}
		it { should have_title(full_title('Sign up'))}
	end
end