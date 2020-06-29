require 'rails_helper'

RSpec.describe "Homesコントローラーのテスト", type: :request do
  describe 'Homes/top' do
    before do
      visit root_path
    end

    it 'aboutリンクが表示される' do
      expect(page).to have_link 'Flip Flapとは？', href: homes_about_path
    end
    it 'aboutページへ遷移できる' do
      find('#about_link').click
      expect(current_path).to eq homes_about_path
    end
    it 'ログインリンクが表示される' do
      expect(page).to have_link 'ログイン', href: new_user_session_path
    end
    it 'ログインページへ遷移できる' do
      find('#login_link').click
      expect(current_path).to eq new_user_session_path
    end
    it '新規登録リンクが表示される' do
      expect(page).to have_link '新規登録', href: new_user_registration_path
    end
    it '新規登録ページへ遷移できる' do
      find('#new_user_link').click
      expect(current_path).to eq new_user_registration_path
    end
  end
end