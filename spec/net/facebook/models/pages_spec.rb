require 'spec_helper'

describe Net::Facebook::Page do
  let(:unknown_username) { 'qeqwe09qlkmhkjh' }
  let(:existing_username) { 'Fullscreeninc' }

  describe '.find_by' do
    subject(:page) { Net::Facebook::Page.find_by username: username }

    context 'given an existing (case-insensitive) username' do
      let (:username) { existing_username }

      it 'returns an object representing the page for that user' do
        expect(page.username).to eq 'fullscreeninc'
        expect(page.likes).to be_an Integer
      end
    end

    context 'given an unknown username' do
      let(:username) { unknown_username }
      it { expect(page).to be_nil }
    end
  end

  describe '.find_by!' do
    subject(:page) { Net::Facebook::Page.find_by! username: username }

    context 'given an existing (case-insensitive) username' do
      let(:username) { existing_username }

      it 'returns an object representing the page for that user' do
        expect(page.username).to eq 'fullscreeninc'
        expect(page.likes).to be_an Integer
      end
    end

    context 'given an unknown username' do
      let(:username) { unknown_username }
      it { expect{page}.to raise_error Net::Facebook::UnknownUser }
    end
  end
end
