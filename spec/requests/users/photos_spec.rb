require 'rails_helper'

RSpec.describe "Photosコントローラーのテスト", type: :request do
  gimei = Gimei.name
  let(:user) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:photo) { create(:photo, user: user)}

  describe 'photos/index' do
    context '未ログインの場合' do
      it 'ログインページへリダイレクトされる' do
        visit photos_path
        expect(current_path).to eq new_user_session_path
      end
    end
    context 'ログイン済の場合' do
      before do
        visit new_user_session_path
        fill_in 'user[email]', with: user.email
        fill_in 'user[password]', with: user.password
        click_button 'ログイン'
        visit photos_path
      end
      it '投稿一覧画面が表示される' do
        expect(current_path).to eq photos_path
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
      it '通知リンクが表示される' do
        expect(page).to have_link '', href: notifications_path
      end
      it 'フォローするボタンが表示されていない' do
        expect(page).to have_no_link 'フォローする'
      end
      it 'フォローユーザーリンクが表示される' do
        expect(page).to have_link '', href: follow_user_path(user)
      end
      it 'フォロワーユーザーリンクが表示される' do
        expect(page).to have_link '', href: follower_user_path(user)
      end
      it '投稿画像が表示される' do
        expect(page).to have_css('#rspec_photo')
      end
      it '投稿詳細リンクが表示される' do
        expect(page).to have_link '', href: photo_path(photo)
      end
    end
  end
end
