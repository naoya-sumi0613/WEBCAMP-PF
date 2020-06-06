class Users::PhotosController < ApplicationController
  before_action :authenticate_user!

  impressionist :actions => [:show], :unique => [:impressionable_id, :user_id]

  def index
    @user = User.find(current_user.id)
    @array = []

    if params[:tag_name]
      @photos = Photo.tagged_with("#{params[:tag_name]}")
      @name = "”#{params[:tag_name]}”一覧"
    elsif params[:follow]
      @photos = Photo.where(user_id: current_user.following_user)
      @name = "投稿一覧"
    else
      @photos = Photo.all
      @name = "投稿一覧"
    end

    #ページネーションが上手くいかなかったため、配列取り出し
    @photos.each do |photo|
      if photo.range == "全ユーザー"
        @array.push(photo)
      elsif photo.range == "フォロワーのみ"
        if current_user.following?(photo.user) || photo.user.id == current_user.id
          @array.push(photo)
        end
      else
        if photo.user.id == current_user.id
          @array.push(photo)
        end
      end
    end

    @photos_array = Kaminari.paginate_array(@array).page(params[:page]).per(12)
  end

  def new
  	@photo = Photo.new
  end

  def create
  	@photo = Photo.new(photo_params)
  	@photo.user_id = current_user.id
  	if @photo.save
      # AI画像処理
      datas = Vision.get_image_data(@photo.image)
      safe_search_annotations = datas['safeSearchAnnotation'].values
      if safe_search_annotations.any?{|a| a == 'VERY_LIKELY' || a == 'LIKELY'}
        @photo.destroy
        render 'new'
      elsif photo_params[:tag_list] == ""
        tags = datas['labelAnnotations'].pluck('description').take(5)
        tags.each do |tag|
          @photo.tag_list.add(tag)
        end
        @photo.save
        redirect_to photo_path(@photo.id)
      end
    else
      render 'new'
    end
  end

  def show
    @photo = Photo.find(params[:id])
    @user = User.find(@photo.user_id)
    @comment = Comment.new
  end

  def update
    @photo = Photo.find(params[:id])
    @photo.update(photo_params)
    redirect_to photo_path(params[:id])
  end

  def destroy
    @photo = Photo.find(params[:id])
    @photo.destroy
    redirect_to user_path(current_user)
  end

  def likes
    @photo = Photo.find(params[:id])
    @likes = Like.where(photo_id: @photo.id).page(params[:page]).per(10)
  end

  def comments
    @photo = Photo.find(params[:id])
    @comments = Comment.where(photo_id: @photo.id).page(params[:page]).per(10)
  end



  def photo_params
  	params.require(:photo).permit(:user_id, :image, :word, :range, :tag_list)
  end
end
