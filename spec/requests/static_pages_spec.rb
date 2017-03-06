require 'spec_helper'

describe "Static pages" do
	#let(:base_title) {"ROR Sample App"}

	subject { page }
	describe "Home page" do
		before { visit '/' }
		it { should have_content('Sample App') }
		it { should have_title(full_title('')) }
		it { should_not have_title('|Home') }
	end

	describe "Help page" do
		before { visit '/help'}
		it { should have_content('Help') }
		it { should have_title(full_title('Help')) }
	end

	describe "About page" do
		before { visit '/about'}
		it { should have_content('About Us') }
		it { should have_title(full_title('About Us')) }
	end

	describe "Contact" do
		before { visit '/contact'}
		it { should have_content('Contact') }
		it { should have_title(full_title("Contact Us")) }
	end
	
	describe "Test" do
		it "should have the content 'Test'" do
			visit '/static_pages/test'
			expect(page).to have_content('Test')
		end
	end
	describe "Test Title" do
		it "should have the right title" do
			visit '/static_pages/test'
			expect(page).to have_title("ROR Sample App")
		end
	end
end