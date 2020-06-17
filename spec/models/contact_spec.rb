require 'rails_helper'

RSpec.describe 'Contactモデルのテスト', type: :model do
  let(:contact){ create :contact}

  describe 'バリデーション' do
    context "お問い合わせ送信" do
      it "値が全て正しく入力されていれば保存される" do
        expect(contact).to be_valid
      end
    end

    context "titleカラム" do
      it "空欄でないこと" do
        contact.title = ''
        expect(contact.valid?).to eq(false)
      end
      it "50文字以下であること" do
        contact.title = '５０文字５０文字５０文字５０文字５０文字５０文字５０文字５０文字５０文字５０文字５０文字５０文字５０文'
        expect(contact.valid?).to eq(false)
      end
    end

    context "contentカラム" do
      it "空欄でないこと" do
        contact.content = ''
        expect(contact.valid?).to eq(false)
      end
      it "150文字以下であること" do
        contact.content = '１５０文字１５０文字１５０文字１５０文字１５０文字１５０文字１５０文字１５０文字１５０文字１５０文字１５０文字１５０文字１５０文字１５０文字１５０文字１５０文字１５０文字１５０文字１５０文字１５０文字１５０文字１５０文字１５０文字１５０文字１５０文字１５０文字１５０文字１５０文字１５０文字１５０文字１'
        expect(contact.valid?).to eq(false)
      end
    end
  end
end