require 'rails_helper'

RSpec.describe 'Userモデルのテスト', type: :model do

  describe 'バリデーションのテスト' do
    let(:user){ create :user}
    gimei = Gimei.name

    context "新規登録" do
      it '値が全て正しく入力されていれば保存される' do
        expect(user).to be_valid
      end
    end

    context "last_nameカラム" do
      it "空欄でないこと" do
        user.last_name = ''
        expect(user.valid?).to eq(false)
      end
      it "10文字以下であること" do
        user.last_name = Faker::Lorem.characters(number:11)
        expect(user.valid?).to eq(false)
      end
    end

    context "first_nameカラム" do
      it "空欄でないこと" do
        user.first_name = ''
        expect(user.valid?).to eq(false)
      end
      it "10文字以下であること" do
        user.first_name = Faker::Lorem.characters(number:11)
        expect(user.valid?).to eq(false)
      end
    end

    context "read_last_nameカラム" do
      it "空欄でないこと" do
        user.read_last_name = ''
        expect(user.valid?).to eq(false)
      end
      it "20文字以下であること" do
        user.read_last_name = ('ア'..'ン').to_a.sample(21).join
        expect(user.valid?).to eq(false)
      end
      it "入力がカタカナであること" do
        user.read_last_name = gimei.last.hiragana
        expect(user.valid?).to eq(false)
      end
    end

    context "read_first_nameカラム" do
      it "空欄でないこと" do
        user.read_first_name = ''
        expect(user.valid?).to eq(false)
      end
      it "20文字以下であること" do
        user.read_first_name = ('ア'..'ン').to_a.sample(21).join
        expect(user.valid?).to eq(false)
      end
      it "入力がカタカナであること" do
        user.read_first_name = gimei.first.hiragana
        expect(user.valid?).to eq(false)
      end
    end

    context "introductionカラム" do
      it "100文字以下であること" do
        user.introduction = Faker::Lorem.characters(number:101)
        expect(user.valid?).to eq(false)
      end
    end
  end
end
