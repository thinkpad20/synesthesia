class RelationshipsController < ApplicationController

  # POST /relationships
  # POST /relationships.json
  def create
    user = User.find_by_id(params[:user_id])
    @relationship = current_user.follow!(user)

    respond_to do |format|
      if @relationship.valid?
        format.js
        format.html { redirect_to @relationship, notice: 'Relationship was successfully created.' }
        format.json { render json: @relationship, status: :created, location: @relationship }
      else
        format.html { render action: "new" }
        format.json { render json: @relationship.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /relationships/1
  # DELETE /relationships/1.json
  def destroy
    @user = User.find_by_id(params[:user_id])
    puts "#{@user}"
    @relationship = current_user.unfollow!(@user)

    respond_to do |format|
      if @relationship.valid?
        format.js {render 'destroy_row'}
        format.html { redirect_to relationships_url }
        format.json { head :no_content }
      end
    end
  end

  def toggle_follow
   @user = User.find_by_id(params[:user_id])

    if signed_in? && !current_user.following?(@user)
     @relationship = current_user.follow!(@user)
     @follow = true
    elsif signed_in? && current_user.following?(@user)
      @relationship = current_user.unfollow!(@user)
      @follow = false
    end

    respond_to do |format|
      if @relationship.valid? and @follow
        format.js {render 'create'}
        format.html { redirect_to @relationship, notice: "You followed #{@user.username}" }
        format.json { render json: @relationship, status: :created, location: @relationship }
      elsif @relationship.valid? and !@follow
        format.js {render 'destroy'}
        format.html { redirect_to @relationship, notice: "You unfollowed #{@user.username}" }
        format.json { render json: @relationship, status: :created, location: @relationship }
      else
        format.html { render action: "new" }
        format.json { render json: @relationship.errors, status: :unprocessable_entity }
      end
    end
  end

end
