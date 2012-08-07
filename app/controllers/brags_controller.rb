require 'rails3-jquery-autocomplete'

class BragsController < ApplicationController
  before_filter :authenticate_admin!, except: [:autocomplete_brag_content]
  
  autocomplete :brag, :content, full: true

  # GET /brags
  # GET /brags.json
  def index
    @brags = Brag.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @brags }
    end
  end

  # GET /brags/1
  # GET /brags/1.json
  def show
    @brag = Brag.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @brag }
    end
  end

  # GET /brags/new
  # GET /brags/new.json
  def new
    @brag = Brag.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @brag }
    end
  end

  # GET /brags/1/edit
  def edit
    @brag = Brag.find(params[:id])
  end

  # POST /brags
  # POST /brags.json
  def create
    @brag = Brag.new(params[:brag])

    respond_to do |format|
      if @brag.save
        format.html { redirect_to @brag, notice: 'Brag was successfully created.' }
        format.json { render json: @brag, status: :created, location: @brag }
      else
        format.html { render action: "new" }
        format.json { render json: @brag.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /brags/1
  # PUT /brags/1.json
  def update
    @brag = Brag.find(params[:id])

    respond_to do |format|
      if @brag.update_attributes(params[:brag])
        format.html { redirect_to @brag, notice: 'Brag was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @brag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /brags/1
  # DELETE /brags/1.json
  def destroy
    @brag = Brag.find(params[:id])
    @brag.destroy

    respond_to do |format|
      format.html { redirect_to brags_url }
      format.json { head :no_content }
    end
  end
end
