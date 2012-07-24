class FunFactsController < ApplicationController
  before_filter :authenticate_admin!

  # GET /fun_facts
  # GET /fun_facts.json
  def index
    @fun_facts = FunFact.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @fun_facts }
    end
  end

  # GET /fun_facts/1
  # GET /fun_facts/1.json
  def show
    @fun_fact = FunFact.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @fun_fact }
    end
  end

  # GET /fun_facts/new
  # GET /fun_facts/new.json
  def new
    @fun_fact = FunFact.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @fun_fact }
    end
  end

  # GET /fun_facts/1/edit
  def edit
    @fun_fact = FunFact.find(params[:id])
  end

  # POST /fun_facts
  # POST /fun_facts.json
  def create
    @fun_fact = FunFact.new(params[:fun_fact])

    respond_to do |format|
      if @fun_fact.save
        format.html { redirect_to @fun_fact, notice: 'Fun fact was successfully created.' }
        format.json { render json: @fun_fact, status: :created, location: @fun_fact }
      else
        format.html { render action: "new" }
        format.json { render json: @fun_fact.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /fun_facts/1
  # PUT /fun_facts/1.json
  def update
    @fun_fact = FunFact.find(params[:id])

    respond_to do |format|
      if @fun_fact.update_attributes(params[:fun_fact])
        format.html { redirect_to @fun_fact, notice: 'Fun fact was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @fun_fact.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fun_facts/1
  # DELETE /fun_facts/1.json
  def destroy
    @fun_fact = FunFact.find(params[:id])
    @fun_fact.destroy

    respond_to do |format|
      format.html { redirect_to fun_facts_url }
      format.json { head :no_content }
    end
  end
end
