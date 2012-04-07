require 'spec_helper'

describe DivisionsController do
  login_admin
  
  before do
    @league = FactoryGirl.create(:league)
  end

  it "should have current_admin" do
    subject.current_admin.should_not be_nil
  end
  
  def valid_attributes
    { name:"NFC West", league_id: @league.id }
  end

  describe "GET index" do
    it "assigns all divisions as @divisions" do
      division = Division.create! valid_attributes
      get :index, {}
      assigns(:divisions).should eq([division])
    end
  end

  describe "GET show" do
    it "assigns the requested division as @division" do
      division = Division.create! valid_attributes
      get :show, {:id => division.to_param}
      assigns(:division).should eq(division)
    end
  end

  describe "GET new" do
    it "assigns a new division as @division" do
      get :new, {}
      assigns(:division).should be_a_new(Division)
    end
  end

  describe "GET edit" do
    it "assigns the requested division as @division" do
      division = Division.create! valid_attributes
      get :edit, {:id => division.to_param}
      assigns(:division).should eq(division)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Division" do
        expect {
          post :create, {:division => valid_attributes}
        }.to change(Division, :count).by(1)
      end

      it "assigns a newly created division as @division" do
        post :create, {:division => valid_attributes}
        assigns(:division).should be_a(Division)
        assigns(:division).should be_persisted
      end

      it "redirects to the created division" do
        post :create, {:division => valid_attributes}
        response.should redirect_to(Division.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved division as @division" do
        # Trigger the behavior that occurs when invalid params are submitted
        Division.any_instance.stub(:save).and_return(false)
        post :create, {:division => {}}
        assigns(:division).should be_a_new(Division)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Division.any_instance.stub(:save).and_return(false)
        post :create, {:division => {}}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested division" do
        division = Division.create! valid_attributes
        # Assuming there are no other divisions in the database, this
        # specifies that the Division created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Division.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => division.to_param, :division => {'these' => 'params'}}
      end

      it "assigns the requested division as @division" do
        division = Division.create! valid_attributes
        put :update, {:id => division.to_param, :division => valid_attributes}
        assigns(:division).should eq(division)
      end

      it "redirects to the division" do
        division = Division.create! valid_attributes
        put :update, {:id => division.to_param, :division => valid_attributes}
        response.should redirect_to(division)
      end
    end

    describe "with invalid params" do
      it "assigns the division as @division" do
        division = Division.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Division.any_instance.stub(:save).and_return(false)
        put :update, {:id => division.to_param, :division => {}}
        assigns(:division).should eq(division)
      end

      it "re-renders the 'edit' template" do
        division = Division.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Division.any_instance.stub(:save).and_return(false)
        put :update, {:id => division.to_param, :division => {}}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested division" do
      division = Division.create! valid_attributes
      expect {
        delete :destroy, {:id => division.to_param}
      }.to change(Division, :count).by(-1)
    end

    it "redirects to the divisions list" do
      division = Division.create! valid_attributes
      delete :destroy, {:id => division.to_param}
      response.should redirect_to(divisions_url)
    end
  end

end
