# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) do
    User.new(username: 'usernameA',
             password: 'passwordB',
             password_confirmation: 'passwordB')
  end

  describe 'User creation' do
    it 'should be valid' do
      expect(user.valid?).to be(true)
    end

    it 'name should be present' do
      user.username = '     '
      expect(user.valid?).to be(false)
    end

    it 'password should be present' do
      user.password = '     '
      expect(user.valid?).to be(false)
    end

    it 'password should match confirmation' do
      user.password_confirmation = 'passwordC'
      expect(user.valid?).to be(false)
    end

    it 'username cannot be too long' do
      user.username = 'a' * 17
      expect(user.valid?).to be(false)
    end

    it 'password cannot be too long' do
      user.password = 'a' * 17
      user.password_confirmation = 'a' * 17
      expect(user.valid?).to be(false)
    end

    it 'username should be unique' do
      duplicate_user = user.dup
      user.save
      expect(duplicate_user.valid?).to be(false)
    end

    it 'username should not contain spaces' do
      user.username = 'A space'
      expect(user.valid?).to be(false)
    end

    it 'password should not contain spaces' do
      user.password = user.password_confirmation = 'A space'
      expect(user.valid?).to be(false)
    end

    it 'authenticate user true' do
      expect(!!user.authenticate('passwordB')).to be(true)
    end

    it 'authenticate user false' do
      expect(!!user.authenticate('passwordC')).to be(false)
    end
  end
end
