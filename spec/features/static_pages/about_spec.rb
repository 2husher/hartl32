require 'spec_helper'

feature "Static pages" do
  subject { page }

  shared_examples_for "all static pages" do
    it { should have_css('h1', text: heading) }
    it { should have_title(full_title(page_title)) }
  end

  feature "About page" do
    before { visit about_path }

    given(:heading) { "About Us" }
    given(:page_title) { "About Us" }

    it_should_behave_like "all static pages"
  end
end