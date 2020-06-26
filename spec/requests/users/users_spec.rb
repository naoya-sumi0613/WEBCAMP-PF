require 'rails_helper'

RSpec.describe "Usersコントローラーのテスト", type: :request do
  gimei = Gimei.name
  let(:user) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:photo) { create(:photo, user: user)}

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
        expect(page).to have_css('img.image')
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

  describe 'Users/edit' do
    context '未ログインの場合' do
      it 'ログインページへリダイレクトされる' do
        visit edit_user_path(user)
        expect(page).to have_content('ログイン')
      end
    end
    context 'ログイン済の場合' do
      before do
        visit new_user_session_path
        fill_in 'user[email]', with: user.email
        fill_in 'user[password]', with: user.password
        click_button 'ログイン'
        visit edit_user_path(user)
      end
      it 'ユーザー編集画面が表示される' do
        expect(current_path).to eq edit_user_path(user)
      end
      it '他ユーザー編集画面には遷移できない' do
        visit edit_user_path(user2)
        expect(current_path).to eq user_path(user)
      end
      it '"画像"編集フォームが表示される' do
        expect(page).to have_field 'user[image]'
      end
      it '"姓"編集フォームに自分の"姓"が表示される' do
        expect(page).to have_field 'user[last_name]', with: user.last_name
      end
      it '"名"編集フォームに自分の"名"が表示される' do
        expect(page).to have_field 'user[first_name]', with: user.first_name
      end
      it '"セイ"編集フォームに自分の"セイ"が表示される' do
        expect(page).to have_field 'user[read_last_name]', with: user.read_last_name
      end
      it '"メイ"編集フォームに自分の"メイ"が表示される' do
        expect(page).to have_field 'user[read_first_name]', with: user.read_first_name
      end
      it '"メールアドレス"編集フォームに自分の"メールアドレス"が表示される' do
        expect(page).to have_field 'user[email]', with: user.email
      end
      it '"自己紹介"編集フォームが表示される' do
        expect(page).to have_field 'user[introduction]'
      end
      it '更新ボタンが表示される' do
        expect(page).to have_button '更新する'
      end
      it '退会リンクが表示される' do
        expect(page).to have_link '退会', href: retire_user_path(user)
      end
      it '更新に成功する' do
        fill_in 'user[last_name]', with: gimei.last.kanji
        fill_in 'user[first_name]', with: gimei.first.kanji
        fill_in 'user[read_last_name]', with: gimei.last.katakana
        fill_in 'user[read_first_name]', with: gimei.first.katakana
        fill_in 'user[email]', with: Faker::Internet.email
        fill_in 'user[introduction]', with: Faker::Lorem.characters(number:80)
        click_button '更新する'
        expect(page).to have_content 'あなたの投稿一覧'
      end
      it '"姓"が空欄の時"姓を入力してください"と表示され、更新に失敗する' do
        fill_in 'user[last_name]', with: ""
        click_button '更新する'
        expect(page).to have_content '姓を入力してください'
      end
      it '"名"が空欄の時"名を入力してください"と表示され、更新に失敗する' do
        fill_in 'user[first_name]', with: ""
        click_button '更新する'
        expect(page).to have_content '名を入力してください'
      end
      it '"セイ"が空欄の時"セイを入力してください"と表示され、更新に失敗する' do
        fill_in 'user[read_last_name]', with: ""
        click_button '更新する'
        expect(page).to have_content 'セイを入力してください'
      end
      it '"メイ"が空欄の時"メイを入力してください"と表示され、更新に失敗する' do
        fill_in 'user[read_first_name]', with: ""
        click_button '更新する'
        expect(page).to have_content 'メイを入力してください'
      end
      it '"メールアドレス"が空欄の時"メールアドレスを入力してください"と表示され、更新に失敗する' do
        fill_in 'user[email]', with: ""
        click_button '更新する'
        expect(page).to have_content 'メールアドレスを入力してください'
      end
    end
  end
end
