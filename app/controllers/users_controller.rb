class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  def index
    foo
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create

    @user = User.new(params[:user])
    email_res = User.validate_email(@user.email)
    if not email_res.nil?
      respond_to do |format|
          format.html { redirect_to new_user_url, notice: "Email #{email_res[:message]}" }
      end

    elsif !@user.valid?

        # return redirect - email or username is already taken
        respond_to do |format|
          format.html { redirect_to new_user_url, notice: "#{@user.errors.full_messages.join(', ')}" }
          #TODO: render JSON
        end
        
    else
        # else save user
        @user.password_hash = PasswordHash.createHash(params[:password])

        respond_to do |format|
          if @user.save
            session[:user_id] = @user.id
            format.html { redirect_to user_path(@user), notice: "Welcome to Synesthesia, #{@user.username}." }
            format.json { render json: @user, status: :created, location: @user }
          else
            format.html { render action: "new", notice: "Error"}
            format.json { render json: @user.errors, status: :unprocessable_entity }
          end
        end
    end

  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end
end
