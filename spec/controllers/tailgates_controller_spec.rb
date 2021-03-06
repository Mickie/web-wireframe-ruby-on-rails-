require 'spec_helper'

describe TailgatesController do
  
  before do
    mock_geocoding!

    @team = FactoryGirl.create(:team)
    @user = FactoryGirl.create(:user)
  end

  def valid_attributes( aUserId = @user.id)
    { 
      name:'Seahawks Party', 
      team_id:@team.id,
      user_id:aUserId,
      topic_tags:"#seahawks" 
    }
  end

  describe "GET index" do
    it "assigns all tailgates as @tailgates" do
      tailgate = Tailgate.create! valid_attributes
      get :index, {}
      assigns(:tailgates).should eq([tailgate])
    end
  end

  describe "GET show" do
    before do
      @tailgate = Tailgate.create! valid_attributes
      get :show, {:id => @tailgate.to_param}
    end
    it "assigns the requested tailgate as @tailgate" do
      assigns(:tailgate).should eq(@tailgate)
    end

    it "assigns a new post for use in forms" do
      assigns(:post).should be_a(Post)
    end
  end

  describe "GET new" do
    it "redirects to login page if no user" do
      get :new, {}
      response.should redirect_to(new_user_session_path)
    end
    
    describe "with logged in user" do
      login_user
      
      before do
        get :new, {}
      end

      it "assigns a new tailgate as @tailgate" do
        assigns(:tailgate).should be_a_new(Tailgate)
      end

      it "the new tailgate should be associated with logged in user" do
        assigns(:tailgate).user_id.should eq(subject.current_user.id) 
      end

      it "assigns a new tailgate_venue for use in form" do
        assigns(:tailgateVenue).should be_a(TailgateVenue)
        assigns(:tailgateVenue).tailgate.should eq(assigns(:tailgate))
      end
    end
  end

  describe "GET edit" do
    it "redirects to login page if no user" do
      get :new, {}
      response.should redirect_to(new_user_session_path)
    end

    describe "with logged in user" do
      login_user
      
      it "assigns the requested tailgate as @tailgate" do
        tailgate = Tailgate.create! valid_attributes(subject.current_user.id)
        get :edit, {:id => tailgate.to_param}
        assigns(:tailgate).should eq(tailgate)
      end
      
      describe "when logged in user is different from tailgate owner" do

        it "redirects the user to their profile page" do
          tailgate = Tailgate.create! valid_attributes
          get :edit, {:id => tailgate.to_param}
          response.should redirect_to( user_path(subject.current_user) )
        end
        
      end
    end
  end

  describe "POST create" do
    it "redirects to login page if no user" do
      post :create, {:tailgate => valid_attributes}
      response.should redirect_to(new_user_session_path)
    end
    
    describe "with logged in user" do
      login_user
      
      describe "with valid params" do

        it "creates a new Tailgate" do
          expect {
            post :create, {:tailgate => valid_attributes(subject.current_user.id)}
          }.to change(Tailgate, :count).by(1)
        end
  
        it "assigns a newly created tailgate as @tailgate" do
          post :create, {:tailgate => valid_attributes(subject.current_user.id) }
          assigns(:tailgate).should be_a(Tailgate)
          assigns(:tailgate).should be_persisted
        end
  
        it "redirects to the created tailgate" do
          post :create, {:tailgate => valid_attributes(subject.current_user.id) }
          response.should redirect_to(Tailgate.last)
        end
      end
  
      describe "with invalid params" do
        it "assigns a newly created but unsaved tailgate as @tailgate" do
          # Trigger the behavior that occurs when invalid params are submitted
          Tailgate.any_instance.stub(:save).and_return(false)
          post :create, {:tailgate => {team_id:@team.id}}
          assigns(:tailgate).should be_a_new(Tailgate)
        end
  
        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Tailgate.any_instance.stub(:save).and_return(false)
          post :create, {:tailgate => {team_id:@team.id}}
          response.should render_template("new")
        end

        it "re-renders the 'new' template if the user accounts don't match" do
          post :create, {:tailgate => valid_attributes}
          response.should render_template("new")
        end

      end
    end
  end

  describe "PUT update" do
    it "redirects to login page if no user" do
      tailgate = Tailgate.create! valid_attributes
      put :update, {:id => tailgate.to_param, :tailgate => {'these' => 'params'}}
      response.should redirect_to(new_user_session_path)
    end
    
    describe "with logged in user" do
      login_user
      
      describe "with valid params" do
        it "updates the requested tailgate" do
          tailgate = Tailgate.create! valid_attributes(subject.current_user.id)
          # Assuming there are no other tailgates in the database, this
          # specifies that the Tailgate created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          Tailgate.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, {:id => tailgate.to_param, :tailgate => {'these' => 'params'}}
        end
  
        it "assigns the requested tailgate as @tailgate" do
          tailgate = Tailgate.create! valid_attributes(subject.current_user.id)
          put :update, {:id => tailgate.to_param, :tailgate => valid_attributes(subject.current_user.id)}
          assigns(:tailgate).should eq(tailgate)
        end
  
        it "redirects to the tailgate" do
          tailgate = Tailgate.create! valid_attributes(subject.current_user.id)
          put :update, {:id => tailgate.to_param, :tailgate => valid_attributes(subject.current_user.id)}
          response.should redirect_to(tailgate)
        end
      end
  
      describe "with invalid params" do
        it "assigns the tailgate as @tailgate" do
          tailgate = Tailgate.create! valid_attributes(subject.current_user.id)
          # Trigger the behavior that occurs when invalid params are submitted
          Tailgate.any_instance.stub(:save).and_return(false)
          put :update, {:id => tailgate.to_param, :tailgate => {}}
          assigns(:tailgate).should eq(tailgate)
        end
  
        it "re-renders the 'edit' template" do
          tailgate = Tailgate.create! valid_attributes(subject.current_user.id)
          # Trigger the behavior that occurs when invalid params are submitted
          Tailgate.any_instance.stub(:save).and_return(false)
          put :update, {:id => tailgate.to_param, :tailgate => {}}
          response.should render_template("edit")
        end

        it "redirects to the user profile page if users don't match" do
          tailgate = Tailgate.create! valid_attributes
          valid_attributes[:user_id] = @user.id
          put :update, {:id => tailgate.to_param, :tailgate => valid_attributes(subject.current_user.id) }
          response.should redirect_to(user_path(subject.current_user))
        end

      end
    end
  end

  describe "DELETE destroy" do
    it "redirects to login page if no user" do
      tailgate = Tailgate.create! valid_attributes
      put :update, {:id => tailgate.to_param, :tailgate => {'these' => 'params'}}
      response.should redirect_to(new_user_session_path)
    end
    
    describe "with logged in user" do
      login_user

      it "destroys the requested tailgate" do
        tailgate = Tailgate.create! valid_attributes(subject.current_user.id)
        expect {
          delete :destroy, {:id => tailgate.to_param}
        }.to change(Tailgate, :count).by(-1)
      end
  
      it "redirects to the tailgates list" do
        tailgate = Tailgate.create! valid_attributes(subject.current_user.id)
        delete :destroy, {:id => tailgate.to_param}
        response.should redirect_to(tailgates_url)
      end
      
      it "redirects to the root path if users don't match" do
        tailgate = Tailgate.create! valid_attributes
        delete :destroy, {:id => tailgate.to_param}
        response.should redirect_to(root_path)
      end
    end
  end
  
  describe "cleanupTags" do
    it "removes extra spaces at beginning and end" do
      subject.cleanupTags(" foo ").should eq("foo")
    end
    
    it "adds comma before hash tag" do
      subject.cleanupTags(" foo #bar ").should eq("foo, #bar")
      subject.cleanupTags(" #foo #bar ").should eq("#foo, #bar")
    end
    
    it "handles initial space" do
      subject.cleanupTags(" #tag").should eq("#tag")
    end
    
    it "handles pound space quote" do
      subject.cleanupTags("#foo   \"topic\" ").should eq("#foo, \"topic\"")
      subject.cleanupTags("#foo \"topic\"").should eq("#foo, \"topic\"")
    end
    
    it "handles already good content" do
      subject.cleanupTags("#foo, \"topic\"").should eq("#foo, \"topic\"")
      subject.cleanupTags("#foo, #bar").should eq("#foo, #bar")
      subject.cleanupTags("\"topic\", #bar").should eq("\"topic\", #bar")
      subject.cleanupTags("\"topic\", \"topic2\"").should eq("\"topic\", \"topic2\"")
      subject.cleanupTags("foo, topic").should eq("foo, topic")
    end
    
    it "handles just words" do
      subject.cleanupTags("foo topic").should eq("foo topic")
    end
    
    it "handles more cases" do
      subject.cleanupTags(" #tag ").should eq("#tag")
      subject.cleanupTags(" \"topic awesome\" #tag    ").should eq("\"topic awesome\", #tag")
      subject.cleanupTags(" \"topic awesome\" #tag #bar").should eq("\"topic awesome\", #tag, #bar")
      subject.cleanupTags("  #tag, \"foo\"").should eq("#tag, \"foo\"")
      subject.cleanupTags("  #tag, \"foo\",   #bar").should eq("#tag, \"foo\", #bar")
    end
  end

end
