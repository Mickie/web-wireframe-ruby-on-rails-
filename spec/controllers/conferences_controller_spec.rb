require 'spec_helper'

describe ConferencesController do
  login_admin
  
  before do
    @league = FactoryGirl.create(:league)
  end

  it "should have current_admin" do
    subject.current_admin.should_not be_nil
  end
  
  def valid_attributes
    { name:"NFC", league_id: @league.id }
  end

  describe "GET index" do
    it "assigns all conferences as @conferences" do
      conference = Conference.create! valid_attributes
      get :index, {}
      assigns(:conferences).should eq([conference])
    end
  end

  describe "GET show" do
    it "assigns the requested conference as @conference" do
      conference = Conference.create! valid_attributes
      get :show, {:id => conference.to_param}
      assigns(:conference).should eq(conference)
    end
  end

  describe "GET new" do
    it "assigns a new conference as @conference" do
      get :new, {}
      assigns(:conference).should be_a_new(Conference)
    end
  end

  describe "GET edit" do
    it "assigns the requested conference as @conference" do
      conference = Conference.create! valid_attributes
      get :edit, {:id => conference.to_param}
      assigns(:conference).should eq(conference)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Conference" do
        expect {
          post :create, {:conference => valid_attributes}
        }.to change(Conference, :count).by(1)
      end

      it "assigns a newly created conference as @conference" do
        post :create, {:conference => valid_attributes}
        assigns(:conference).should be_a(Conference)
        assigns(:conference).should be_persisted
      end

      it "redirects to the created conference" do
        post :create, {:conference => valid_attributes}
        response.should redirect_to(Conference.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved conference as @conference" do
        # Trigger the behavior that occurs when invalid params are submitted
        Conference.any_instance.stub(:save).and_return(false)
        post :create, {:conference => {}}
        assigns(:conference).should be_a_new(Conference)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Conference.any_instance.stub(:save).and_return(false)
        post :create, {:conference => {}}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested conference" do
        conference = Conference.create! valid_attributes
        # Assuming there are no other conferences in the database, this
        # specifies that the Conference created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Conference.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => conference.to_param, :conference => {'these' => 'params'}}
      end

      it "assigns the requested conference as @conference" do
        conference = Conference.create! valid_attributes
        put :update, {:id => conference.to_param, :conference => valid_attributes}
        assigns(:conference).should eq(conference)
      end

      it "redirects to the conference" do
        conference = Conference.create! valid_attributes
        put :update, {:id => conference.to_param, :conference => valid_attributes}
        response.should redirect_to(conference)
      end
    end

    describe "with invalid params" do
      it "assigns the conference as @conference" do
        conference = Conference.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Conference.any_instance.stub(:save).and_return(false)
        put :update, {:id => conference.to_param, :conference => {}}
        assigns(:conference).should eq(conference)
      end

      it "re-renders the 'edit' template" do
        conference = Conference.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Conference.any_instance.stub(:save).and_return(false)
        put :update, {:id => conference.to_param, :conference => {}}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested conference" do
      conference = Conference.create! valid_attributes
      expect {
        delete :destroy, {:id => conference.to_param}
      }.to change(Conference, :count).by(-1)
    end

    it "redirects to the conferences list" do
      conference = Conference.create! valid_attributes
      delete :destroy, {:id => conference.to_param}
      response.should redirect_to(conferences_url)
    end
  end

end
