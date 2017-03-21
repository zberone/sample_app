require 'spec_helper'

=begin
RSpec.describe "AuthenticationPages", type: :request do
  describe "GET /authentication_pages" do
    it "works! (now write some real specs)" do
      get authentication_pages_index_path
      expect(response).to have_http_status(200)
    end
  end
end
=end

describe "Authentication" do
	subject {page}
	describe "signin page" do
		before { visit signin_path }
		it { should have_content( 'Sign in')}
		it { should have_title( 'Sign in')}
	end
	describe "signin" do
		before { visit signin_path }
		describe "with invalid information" do
			before { click_button "Sign in"}
			it { should have_title( 'Sign in')}
			it { should have_selector('div.alert.alert-error', text: 'Invalid')}
			describe "after visiting another page" do
				before { click_link "Home"}
				it { should_not have_selector('div.alert.alert-error')}
			end
		end
		describe "with valid information" do
			let(:user) { FactoryGirl.create(:user)}
			before { sign_in user}

			it { should have_title(user.name)}
			it { should have_link('Profile', href: user_path(user))}
			it { should have_link('Sign out', href: signout_path)}
			it { should_not have_link('Sign in', href: signin_path)}
			it { should have_link('Settings', href: edit_user_path(user))}
			it { should have_link('Users', href: users_path)}

			describe "followed by signout" do
				before { click_link "Sign out"}
				it { should have_link('Sign in')}
			end
		end
	end
	describe "for non-signed-in users" do
		let(:user){FactoryGirl.create(:user)}
		describe "in the Users controller" do
			describe "visiting the edit page" do
				before { visit edit_user_path(user)}
				it{ should have_title('Sign in')}
			end
			describe "submitting to the update action", type: :request do
				before { patch user_path(user)}
				specify { expect(response).to redirect_to(signin_path) }
			end
		end
		describe "when attempting to visit a protected page" do
			before do
				visit edit_user_path(user)
				fill_in "Email", with: user.email
				fill_in "Password", with: user.password
				click_button "Sign in"
			end
			describe "after signing in" do
				it "should render the desired protected page" do
					expect(page).to have_title('Edit user')
				end
			end
		end
		describe "visiting the user index" do
			before { visit users_path }
			it { should have_title('Sign in')}
		end
	end
	describe "as wrong user" do
		let(:user){ FactoryGirl.create(:user)}
		let(:wrong_user){ FactoryGirl.create(:user, email: "wrong@example.com")}
		before { sign_in user, no_capybara:true }
		describe "visiting Users#edit page", type: :request do
			before { visit edit_user_path(wrong_user)}
			it{ should_not have_title(full_title('Edit user'))}
		end
		describe "submitting a PATCH request to the Users#update action", type: :request do
			before { patch user_path(wrong_user)}
			specify { expect(response).to redirect_to(root_path)}
		end
	end
	describe "as non-admin user" do
		let(:user){ FactoryGirl.create(:user)}
		let(:non_admin){ FactoryGirl.create(:user)}

		before {sign_in non_admin, no_capybara: true }
		describe "submitting a DELETE request to the Users#destroy action", type: :request do
			before { delete user_path(user)}
			specify { expect(response).to redirect_to(root_path)}
		end
	end
	
end