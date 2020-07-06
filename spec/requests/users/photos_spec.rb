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

  describe 'photos/show' do
    context '未ログインの場合' do
      it 'ログインページへリダイレクトされる' do
        visit photo_path(photo)
        expect(current_path).to eq new_user_session_path
      end
    end
    context 'ログイン済の場合' do
      before do
        visit new_user_session_path
        fill_in 'user[email]', with: user.email
        fill_in 'user[password]', with: user.password
        click_button 'ログイン'
        visit photo_path(photo)
      end
      it '投稿詳細画面が表示される' do
        expect(current_path).to eq photo_path(photo)
      end
      it 'ユーザー画像が表示される' do
        expect(page).to have_css('img.image')
      end
      it 'ユーザー名が表示される' do
        expect(page).to have_content("#{photo.user.last_name} #{photo.user.first_name}")
      end
      it 'ユーザーリンクが表示される' do
        expect(page).to have_link '', href: user_path(user)
      end
      it '投稿画像が表示される' do
        expect(page).to have_css('#rspec_photo')
      end
      it '投稿した日付が表示される' do
        expect(page).to have_content(photo.created_at.strftime('%Y/%m/%d'))
      end
      it '一言が表示される' do
        expect(page).to have_content(photo.word)
      end
      it 'いいね数が表示される' do
        expect(page).to have_content(photo.likes.count)
      end
      it 'いいねしたユーザーリンクが表示される' do
        expect(page).to have_link '', href: photo_likes_path(photo)
      end
      it 'コメント数が表示される' do
        expect(page).to have_content(photo.comments.count)
      end
      it 'コメントしたユーザーリンクが表示される' do
        expect(page).to have_link '', href: photo_comments_path(photo)
      end
      it '閲覧数が表示される' do
        expect(page).to have_content(photo.impressions_count)
      end
      it '削除ボタンが表示される' do
        expect(page).to have_css('.fa-trash-alt')
      end
      # 削除処理を追加したい

      it 'セレクトボックスの初期値が現在の公開範囲になっている' do
        expect(page).to have_select(selected: photo.range)
      end
      it 'セレクトボックスの値が"全ユーザー","フォロワーのみ","自分のみ"となっている' do
        expect(page).to have_select(options: ['全ユーザー', 'フォロワーのみ', '自分のみ'])
      end
      it '更新ボタンが表示される' do
        expect(page).to have_button '更新'
      end
      # 更新処理を追加したい

      it 'コメント欄が表示される' do
        expect(page).to have_field 'comment[comment]'
      end
      it 'コメントするボタンが表示される' do
        expect(page).to have_button 'コメントする'
      end
    end
  end

  describe 'photos/new' do
    context '未ログインの場合' do
      it 'ログインページへリダイレクトされる' do
        visit new_photo_path
        expect(current_path).to eq new_user_session_path
      end
    end
    context 'ログイン済の場合' do
      before do
        visit new_user_session_path
        fill_in 'user[email]', with: user.email
        fill_in 'user[password]', with: user.password
        click_button 'ログイン'
        visit new_photo_path
      end
      it '投稿画面が表示される' do
        expect(current_path).to eq new_photo_path
      end
      it '"画像"選択フォームが表示される' do
        expect(page).to have_field 'photo[image]'
      end
      it '"一言"入力フォームが表示される' do
        expect(page).to have_field 'photo[word]'
      end
      it '"タグ"入力フォームが表示される' do
        expect(page).to have_field 'photo[tag_list]'
      end
      it '"公開範囲"選択フォームが表示される' do
        expect(page).to have_field 'photo[range]'
      end
      it '投稿するボタンが表示される' do
        expect(page).to have_button '投稿する'
      end
    end
  end
end