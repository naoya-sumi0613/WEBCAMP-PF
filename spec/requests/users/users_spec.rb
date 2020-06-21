require 'rails_helper'

RSpec.describe "Usersコントローラーのテスト", type: :request do
  gimei = Gimei.name
  let(:user) {create(:user) }

  describe "新規登録のテスト" do
    before do
      visit new_user_registration_path
    end

    it '新規登録画面の表示に成功すること' do
      expect(current_path).to eq new_user_registration_path
    end
    it '新規登録に成功すること' do
      fill_in 'user[last_name]', with: gimei.last.kanji
      fill_in 'user[first_name]', with: gimei.first.kanji
      fill_in 'user[read_last_name]', with: gimei.last.katakana
      fill_in 'user[read_first_name]', with: gimei.first.katakana
      fill_in 'user[email]', with: Faker::Internet.email
      fill_in 'user[password]', with: "password"
      fill_in 'user[password_confirmation]', with: "password"
      click_button '新規登録'

      expect(current_path).to eq user_path(user)
    end
  end

  describe "ログインのテスト" do
    before do
      visit new_user_session_path
    end

    it 'ログイン画面の表示に成功すること' do
      expect(current_path).to eq new_user_session_path
    end
    it 'ログインに成功すること' do
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'ログイン'

      expect(current_path).to eq user_path(user)
    end
  end
end
