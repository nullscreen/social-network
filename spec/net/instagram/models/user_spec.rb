require 'spec_helper'
require 'net/instagram'

describe Net::Instagram::User, :vcr do
  before :all do
    Net::Instagram.configure do |config|
      if config.client_id.blank?
        config.client_id = 'CLIENT_ID'
      end
    end
  end

  let(:existing_username) { 'Fullscreen' }
  let(:unknown_username) { '01LjqweoojkjR' }
  let(:private_username) { 'brohemian' }

  describe '.find_by' do
    subject(:user) { Net::Instagram::User.find_by username: username }

    context 'given an existing (case-insensitive) username' do
      let(:username) { existing_username }

      it 'returns an object representing that user' do
        expect(user.username).to eq 'fullscreen'
        expect(user.follower_count).to be_an Integer
      end
    end

    context 'given an unknown username' do
      let(:username) { unknown_username }

      it 'returns nil' do
        expect(user).to be_nil
      end
    end

    context 'given a private username' do
      let(:username) { private_username }

      it 'returns nil' do
        expect(user).to be_nil
      end
    end
  end

  describe '.find_by!' do
    subject(:user) { Net::Instagram::User.find_by! username: username }
    context 'given an existing (case-insensitive) username' do
      let(:username) { existing_username }

      it 'returns an object representing that user' do
        expect(user.username).to eq 'fullscreen'
        expect(user.follower_count).to be_an Integer
      end
    end

    context 'given an unknown username' do
      let(:username) { unknown_username }

      it 'raises an UnknownUser error' do
        expect{user}.to raise_error Net::Instagram::UnknownUser
      end
    end

    context 'given a private username' do
      let(:username) { private_username }

      it 'raises a PrivateUser error' do
        expect{user}.to raise_error Net::Instagram::PrivateUser
      end
    end
  end
end
