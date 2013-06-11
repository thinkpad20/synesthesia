class LikesController < ApplicationController
  # GET /likes
  # GET /likes.json
  def index
    @likes = Like.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @likes }
    end
  end

  # GET /likes/1
  # GET /likes/1.json
  def show
    @like = Like.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @like }
    end
  end

  # GET /likes/new
  # GET /likes/new.json
  def new
    @like = Like.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @like }
    end
  end

  # GET /likes/1/edit
  def edit
    @like = Like.find(params[:id])
  end

  # POST /likes
  # POST /likes.json
  def create
    @like = Like.new
    puts "#{params}"
    @like.user_id = params[:user_id]
    @like.sound_id = params[:sound_id]

    respond_to do |format|
      if @like.save
        format.js
        format.html { redirect_to @like, notice: 'Like was successfully created.' }
        format.json { render json: @like, status: :created, location: @like }
      else
        format.html { render action: "new" }
        format.json { render json: @like.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /likes/1
  # PUT /likes/1.json
  def update
    @like = Like.find(params[:id])

    respond_to do |format|
      if @like.update_attributes(params[:like])
        format.html { redirect_to @like, notice: 'Like was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @like.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /likes/1
  # DELETE /likes/1.json
  def destroy
    @like = Like.find(params[:id])
    @like.destroy

    puts ""

    respond_to do |format|
      format.js
      format.html { redirect_to likes_url }
      format.json { head :no_content }
    end
  end

    def toggle_like
      puts "#{params}"
      @user_id = params[:user_id]
      @sound_id = params[:sound_id]

     respond_to do |format|
      if Like.like_exists?( @user_id, @sound_id )
        Like.like_for( @user_id, @sound_id ).destroy
        format.js {render 'destroy'}
      else
        Like.create(:user_id=>@user_id, :sound_id=>@sound_id)
        format.js {render 'create'}
      end
    end

  end

end
