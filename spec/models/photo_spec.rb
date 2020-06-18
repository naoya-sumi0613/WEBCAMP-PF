require 'rails_helper'

RSpec.describe 'Photoモデルのテスト', type: :model do

  describe 'バリデーションのテスト' do
    let(:photo){ create :photo}

    context "画像投稿" do
      it '値が正しく入力されていれば保存される' do
        expect(photo).to be_valid
      end
    end

    context "imageカラム" do
      it '画像が選択されていること' do
        photo.image_id = ""
        expect(photo.valid?).to eq(false)
      end
    end

    context "wordカラム" do
      it '空欄でないこと' do
        photo.word = ""
        expect(photo.valid?).to eq(false)
      end
      it '30文字以下であること' do
        photo.word = Faker::Lorem.characters(number:31)
        expect(photo.valid?).to eq(false)
      end
    end

    context "rangeカラム" do
      it '空欄でないこと' do
        photo.range = ""
        expect(photo.valid?).to eq(false)
      end
    end
  end
end