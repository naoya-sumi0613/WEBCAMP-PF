require 'rails_helper'

RSpec.describe User, type: :model do

  context "データが正しく保存される" do
    before do
      @user = User.new
      @user.last_name = "手須戸"
      @user.read_last_name = "テスト"
      @user.full_name = ""
      @user.first_name = "太郎"
      @user.read_first_name = "タロウ"
      @user.read_full_name = ""
      @user.email = "tesuto@tarou"
      @user.password = "tesuto"
      @user.save

    end
    it "全て入力してあるので保存される" do
      expect(@user).to be_valid
    end
  end
end
