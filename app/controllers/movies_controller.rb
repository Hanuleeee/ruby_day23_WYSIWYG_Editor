class MoviesController < ApplicationController
  before_action :js_authenticate_user!, only: [:like_movie, :create_comment, :update_comment, :destroy_comment]
  before_action :authenticate_user!, except: [:index, :show, :search_movie]  # 둘 빼고 로그인한 유저만 보기가능
  before_action :set_movie, only: [:show, :edit, :update, :destroy, :create_comment]

  # GET /movies
  # GET /movies.json
  def index
    @movies = Movie.page(params[:page])
    # respond_to do |format|  # html, js가 왔을때 각각 응답을 다르게 줄수 있다.
    #   format.html
    #   format.js
    # end
  end

  # GET /movies/1
  # GET /movies/1.json
  def show
    @user_likes_movie = Like.where(user_id: current_user.id, movie_id: @movie.id).first if user_signed_in?
    #@comment = Comment.all.reverse
  end

  # GET /movies/new
  def new
    @movie = Movie.new
  end

  # GET /movies/1/edit
  def edit
  end

  # POST /movies
  # POST /movies.json
  def create
    @movie = Movie.new(movie_params)
    @movie.user_id = current_user.id

    respond_to do |format|
      if @movie.save
        format.html { redirect_to @movie, notice: 'Movie was successfully created.' }
        format.json { render :show, status: :created, location: @movie }
      else
        format.html { render :new }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /movies/1
  # PATCH/PUT /movies/1.json
  def update
    respond_to do |format|
      if @movie.update(movie_params)
        format.html { redirect_to @movie, notice: 'Movie was successfully updated.' }
        format.json { render :show, status: :ok, location: @movie }
      else
        format.html { render :edit }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movies/1
  # DELETE /movies/1.json
  def destroy
    @movie.destroy
    respond_to do |format|
      format.html { redirect_to movies_url, notice: 'Movie was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def like_movie
    p params
    # 현재 유저와 params에 담긴 movie간의 좋아요 관계를 설정한다.
    # 만약에 현재 로그인한 유저가 이미 좋아요를 눌렀을 경우-> 해당 Like 인스턴스 삭제
    # 새로 누른 경우 -> 좋아요 관계 설정
    @like = Like.where(user_id: current_user.id, movie_id: params[:movie_id]).first
    if @like.nil?
      @like = Like.create(user_id: current_user.id, movie_id: params[:movie_id])
    else
      @like.destroy
    end
    puts @like.frozen? #이메소드로 새로만든건지, 삭제를 한건지 알수있다.
    # @like.frozen? # @like.destroy처럼 삭제된경우 에는 사용하지못하도록 얼어있어.
    # -> true 라면 좋아요취소된친구
    
    # 현재 유저와 params에 담긴 movie간의 좋아요 관계를 설정한다.
    # Like.create(user_id: current_user.id, movie_id: params[:movie_id])

    puts "좋아요 설정 끝"
  end
  
  def create_comment
    # @movie = Movie.find(params[:id])
    @comment = Comment.create(user_id: current_user.id, movie_id: @movie.id, contents: params[:contents])
    # @movie.comments.new(user_id: current_user.id).save  #위에의 축약형
  end
  
  def destroy_comment
    @comment = Comment.find(params[:comment_id]).destroy
  end
  
  def update_comment
    @comment = Comment.find(params[:comment_id])
    @comment.update(contents: params[:contents])
  end
  
  def search_movie
    #원래는 이 액션명과 일치하는 js파일을 찾아서 data를 보내줌
    #Then, 다른 파일로 보내주어야 할때는 이렇게 쓰면 내가 원하는 js파일로 보낼수 있다. 
    
    respond_to do |format|
      if params[:q].strip.empty? 
        format.js {render 'no content'}
      else
        @movies= Movie.where("title LIKE ?", "#{params[:q]}%")  # 첫글자만 일치하고 뒤(%)는 아무거나
        format.js {render 'search_movie'}
      end
    end

    # if params[:q].strip.empty? 
    #   render nothing: true # 아무 응답없음
    # end
    # @movies = Movie.where("title LIKE ?", "#{params[:q]}%") 
  end
  
  def upload_image
    @image = Image.create(image_path: params[:upload][:image])  # hash 형태라서..
    render json: @image
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_movie
      @movie = Movie.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def movie_params
      params.require(:movie).permit(:title, :genre, :director, :actor, :description, :image_path)
    end
end
