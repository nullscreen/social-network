require 'spec_helper'

describe Net::Facebook::User do
  let(:unknown_username) { 'qeqwe09qlkmhkjh' }
  let(:existing_username) { '1453280268327112' }

  describe '.find_by' do
    subject(:user) { Net::Facebook::User.find_by username: username }

    context 'given an existing (case-insensitive) username' do
      let (:username) { existing_username }

      it 'returns an object representing the user' do
        expect(user.first_name).to eq 'Jeremy'
        expect(user.last_name).to eq 'Dev'
        expect(user.gender).to eq 'male'
      end
    end

    context 'given an unknown username' do
      let(:username) { unknown_username }
      it { expect(user).to be_nil }
    end
  end

  describe '.find_by!' do
    subject(:user) { Net::Facebook::User.find_by! username: username }

    context 'given an existing (case-insensitive) username' do
      let(:username) { existing_username }

      it 'returns an object representing the user' do
        expect(user.first_name).to eq 'Jeremy'
        expect(user.last_name).to eq 'Dev'
        expect(user.gender).to eq 'male'
      end
    end

    context 'given an unknown username' do
      let(:username) { unknown_username }
      it { expect{user}.to raise_error Net::Facebook::UnknownUser }
    end
  end
end
