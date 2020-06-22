require 'rails_helper'

RSpec.describe "Usersコントローラーのテスト", type: :request do
  gimei = Gimei.name
  let(:user) { create(:user) }
  let(:photo) { create(:photo, user: user)}

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

  describe 'Users/show' do
    context '未ログインの場合' do
      it 'ログインページへリダイレクトされる' do
        visit user_path(user)
        expect(page).to have_content('ログイン')
      end
    end
    context 'ログイン済の場合' do
      before do
        visit new_user_session_path
        fill_in 'user[email]', with: user.email
        fill_in 'user[password]', with: user.password
        click_button 'ログイン'
      end
      it 'ユーザー詳細画面が表示される' do
        visit user_path(user)
        expect(current_path).to eq user_path(user)
      end
      it 'ユーザー画像が表示される' do
        expect(page).to have_content(user.image)
      end
      it 'ユーザー名が表示される' do
        expect(page).to have_content("#{user.last_name} #{user.first_name}")
      end
      it 'ユーザー名にふりがながついている' do
        expect(page).to have_content("#{user.read_last_name} #{user.read_first_name}")
      end
      it '自己紹介文が表示される' do
        expect(page).to have_content(user.introduction)
      end
      it '編集リンクが表示される' do
        expect(page).to have_link '', href: edit_user_path(user)
      end
    end
  end
end
