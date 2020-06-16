require 'rails_helper'

RSpec.describe Contact, type: :model do

  context "データが正しく保存される" do
    before do
      @contact = Contact.new
      @contact.user_id = @user
      @contact.title = "お問い合わせ"
      @contact.content = "テストです"
      @contact.save
    end
    it "全て入力してあるので保存される" do
      expect(@contact).to be_valid
    end
  end
end
