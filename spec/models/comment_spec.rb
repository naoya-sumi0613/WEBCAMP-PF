require 'rails_helper'

RSpec.describe 'Commentモデルのテスト', type: :model do

  describe 'バリデーション' do
    let(:comment){ create :comment }

    context "コメント投稿" do
      it "値が全て正しく入力されていれば保存される" do
        expect(comment).to be_valid
      end
    end

    context "commentカラム" do
      it "空欄でないこと" do
        comment.comment = ''
        expect(comment.valid?).to eq(false)
      end
      it "50文字以下であること" do
        comment.comment = Faker::Lorem.characters(number:51)
        expect(comment.valid?).to eq(false)
      end
    end
  end
end
