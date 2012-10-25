require 'spec_helper'

describe FacebookPagesController do

  before do
    mock_geocoding!
    @tailgate = FactoryGirl.create(:tailgate)
  end

  def valid_attributes
    {
      tailgate_id: @tailgate.id
    }
  end

  describe "GET index" do
    login_admin

    it "assigns all facebook_pages as @facebook_pages" do
      facebook_page = FacebookPage.create! valid_attributes
      get :index, {}
      assigns(:facebook_pages).should eq([facebook_page])
    end
  end

  describe "GET show" do
    login_user

    it "assigns the requested facebook_page as @facebook_page" do
      facebook_page = FacebookPage.create! valid_attributes
      get :show, {:id => facebook_page.to_param}
      assigns(:facebook_page).should eq(facebook_page)
    end
  end

  describe "GET new" do
    login_user

    it "assigns a new facebook_page as @facebook_page" do
      get :new, {}
      assigns(:facebook_page).should be_a_new(FacebookPage)
    end
  end

  describe "GET edit" do
    login_user
    it "assigns the requested facebook_page as @facebook_page" do
      facebook_page = FacebookPage.create! valid_attributes
      get :edit, {:id => facebook_page.to_param}
      assigns(:facebook_page).should eq(facebook_page)
    end
  end

  describe "POST create" do
    login_user
    describe "with valid params" do
      it "creates a new FacebookPage" do
        expect {
          post :create, {:facebook_page => valid_attributes}
        }.to change(FacebookPage, :count).by(1)
      end

      it "assigns a newly created facebook_page as @facebook_page" do
        post :create, {:facebook_page => valid_attributes}
        assigns(:facebook_page).should be_a(FacebookPage)
        assigns(:facebook_page).should be_persisted
      end

      it "redirects to the created facebook_page" do
        post :create, {:facebook_page => valid_attributes}
        response.should redirect_to(FacebookPage.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved facebook_page as @facebook_page" do
        # Trigger the behavior that occurs when invalid params are submitted
        FacebookPage.any_instance.stub(:save).and_return(false)
        post :create, {:facebook_page => {}}
        assigns(:facebook_page).should be_a_new(FacebookPage)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        FacebookPage.any_instance.stub(:save).and_return(false)
        post :create, {:facebook_page => {}}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    login_user
    describe "with valid params" do
      it "updates the requested facebook_page" do
        facebook_page = FacebookPage.create! valid_attributes
        # Assuming there are no other facebook_pages in the database, this
        # specifies that the FacebookPage created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        FacebookPage.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => facebook_page.to_param, :facebook_page => {'these' => 'params'}}
      end

      it "assigns the requested facebook_page as @facebook_page" do
        facebook_page = FacebookPage.create! valid_attributes
        put :update, {:id => facebook_page.to_param, :facebook_page => valid_attributes}
        assigns(:facebook_page).should eq(facebook_page)
      end

      it "redirects to the facebook_page" do
        facebook_page = FacebookPage.create! valid_attributes
        put :update, {:id => facebook_page.to_param, :facebook_page => valid_attributes}
        response.should redirect_to(facebook_page)
      end
    end

    describe "with invalid params" do
      it "assigns the facebook_page as @facebook_page" do
        facebook_page = FacebookPage.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        FacebookPage.any_instance.stub(:save).and_return(false)
        put :update, {:id => facebook_page.to_param, :facebook_page => {}}
        assigns(:facebook_page).should eq(facebook_page)
      end

      it "re-renders the 'edit' template" do
        facebook_page = FacebookPage.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        FacebookPage.any_instance.stub(:save).and_return(false)
        put :update, {:id => facebook_page.to_param, :facebook_page => {}}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    login_admin
    it "destroys the requested facebook_page" do
      facebook_page = FacebookPage.create! valid_attributes
      expect {
        delete :destroy, {:id => facebook_page.to_param}
      }.to change(FacebookPage, :count).by(-1)
    end

    it "redirects to the facebook_pages list" do
      facebook_page = FacebookPage.create! valid_attributes
      delete :destroy, {:id => facebook_page.to_param}
      response.should redirect_to(facebook_pages_url)
    end
  end

end
