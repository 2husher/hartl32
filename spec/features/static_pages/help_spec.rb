require 'spec_helper'

feature "Static pages" do
  subject { page }

  shared_examples_for "all static pages" do
    it { should have_css('h1', text: heading) }
    it { should have_title(full_title(page_title)) }
  end

  feature "Help page" do
    before { visit help_path }

    given(:heading) { "Help" }
    given(:page_title) { "Help" }

    it_should_behave_like "all static pages"
  end
end