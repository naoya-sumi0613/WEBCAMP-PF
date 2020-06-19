require 'rails_helper'

RSpec.describe "Usersコントローラーのテスト", type: :request do

  describe 'Users/show' do
    context 'ユーザーが存在する場合' do
      before do
        @user = create(:user)
        get user_path(@user)
      end
      it 'リクエストが成功すること' do
        expect(response.status).to eq 200
      end
    end
  end



  describe "ユーザー新規登録ページ" do
    before do
      get new_user_registration_path
    end
    it '新規登録画面が正しく表示される' do
      expect(response.status).to eq 200
    end
  end
end
