class SoundsController < ApplicationController

  def index
    @sounds = Sound.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sounds }
    end
  end

  def show
    @sound = Sound.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @sound }
    end
  end

  def new
    @sound = Sound.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @sound }
    end
  end

  def edit
    @sound = Sound.find(params[:id])
  end

  def create
    @sound = Sound.new(params[:sound])

    respond_to do |format|
      if @sound.save
        format.html { redirect_to @sound, notice: 'Sound was successfully created.' }
        format.json { render json: @sound, status: :created, location: @sound }
      else
        format.html { render action: "new" }
        format.json { render json: @sound.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @sound = Sound.find(params[:id])

    respond_to do |format|
      if @sound.update_attributes(params[:sound])
        format.html { redirect_to @sound, notice: 'Sound was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @sound.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @sound = Sound.find(params[:id])
    @sound.destroy

    respond_to do |format|
      format.html { redirect_to sounds_url }
      format.json { head :no_content }
    end
  end

end
