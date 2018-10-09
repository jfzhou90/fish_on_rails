# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Login', type: :system do
  before do
    driven_by(:selenium_chrome)
  end

  it 'requires authentication' do
    visit '/'

    expect(page).to have_content 'Username'
    # expect(current_path).to eq new_session_path
  end
end
