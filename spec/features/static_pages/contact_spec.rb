require 'spec_helper'

feature "Static pages" do
  subject { page }

  shared_examples_for "all static pages" do
    it { should have_css('h1', text: heading) }
    it { should have_title(full_title(page_title)) }
  end

  feature "Contact page" do
    before { visit contact_path }

    given(:heading) { "Contact" }
    given(:page_title) { "Contact" }

    it_should_behave_like "all static pages"
  end
end