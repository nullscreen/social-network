require 'spec_helper'
require 'net/twitter'

describe Net::Twitter::User, :vcr do
  let(:unknown_screen_name) { '09hlQHE29534awe' }
  let(:suspended_screen_name) { 'CodFatherLucas' }
  let(:existing_screen_name) { 'fullscreen' }

  describe '.find_by' do
    subject(:user) { Net::Twitter::User.find_by screen_name: screen_name }

    context 'given an existing (case-insensitive) screen name' do
      let(:screen_name) { existing_screen_name }

      it 'returns an object representing that user' do
        expect(user.screen_name).to eq 'Fullscreen'
        expect(user.follower_count).to be_an Integer
      end
    end

    context 'given an unknown screen name' do
      let(:screen_name) { unknown_screen_name }
      it { expect(user).to be_nil }
    end

    context 'given a suspended screen name' do
      let(:screen_name) { suspended_screen_name }
      it { expect(user).to be_nil }
    end
  end

  describe '.find_by!' do
    subject(:user) { Net::Twitter::User.find_by! screen_name: screen_name }

    context 'given an existing (case-insensitive) screen name' do
      let(:screen_name) { existing_screen_name }

      it 'returns an object representing that user' do
        expect(user.screen_name).to eq 'Fullscreen'
        expect(user.follower_count).to be_an Integer
      end
    end

    context 'given an unknown screen name' do
      let(:screen_name) { unknown_screen_name }
      it { expect{user}.to raise_error Net::Twitter::UnknownUser }
    end

    context 'given a suspended screen name' do
      let(:screen_name) { suspended_screen_name }
      it { expect{user}.to raise_error Net::Twitter::SuspendedUser }
    end
  end

  describe '.where' do
    context 'given multiple existing (case-insensitive) screen names' do
      let(:screen_names) { ['brohemian6', existing_screen_name, suspended_screen_name, unknown_screen_name] }
      subject(:users) { Net::Twitter::User.where screen_name: screen_names }

      it 'returns an array of objects representing those users' do
        expect(users.map &:screen_name).to contain_exactly('Fullscreen', 'brohemian6')
        expect(users.map &:follower_count).to all(be_an Integer)
      end
    end

    context 'given multiple unknown or suspended screen names' do
      let(:screen_names) { [suspended_screen_name, unknown_screen_name] }
      subject(:users) { Net::Twitter::User.where screen_name: screen_names }

      it 'returns an empty array' do
        expect(users).to be_empty
      end
    end

    # @see https://dev.twitter.com/rest/reference/get/users/lookup
    context 'given more screen names than allowed by Twitter' do
      let(:screen_names) { ('a'..'z').map{|x| ('a'..'e').map{|y| "#{x}#{y}"}}.flatten }
      subject(:users) { Net::Twitter::User.where screen_name: screen_names }

      it { expect{users}.to raise_error Net::Twitter::TooManyUsers }
    end

    # @see https://dev.twitter.com/rest/public/rate-limits
    context 'called more times than Twitter’s rate limit' do

      before { expect(Time).to receive(:now).at_least(:once).and_return 12345678 }
      let(:lookup_limit) { 60 }
      let(:screen_names) { [existing_screen_name] }
      subject(:user_sets) { (lookup_limit + 1).times.map do
        Net::Twitter::User.where screen_name: screen_names
      end}

      it 'waits for the rate limit to expire then continues' do
        expect(user_sets.compact.size).to be > lookup_limit
      end
    end
  end
end
