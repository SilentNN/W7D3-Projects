require 'rails_helper'

RSpec.describe UsersController, type: :controller do
    describe "#index" do
    end

    describe "#show" do
    end

    describe "#new" do
        it "should render a new user form" do
            get :new
            expect(response).to render_template(:new)
        end
    end
    
    describe "#create" do
        let(:valid_params) {{ user: {username: "Michael", password: "bluebird"} }}
        let(:invalid_params) {{ user: {password: "bluebird"} }}
        let(:user) { User.find_by(username: "Michael") }
    
        context "with valid parameters" do
            before :each do
                post :create, params: valid_params
            end
            
            it "should be saved to db" do
                expect(User.find_by_credentials(valid_params[username], valid_params[password])).to_not be_nil
            end
            
            it "redirects to user#show" do
                expect(response).to redirect_to(user_url(user))
            end

            it "logs new user in" do 
                expect(User.find_by_credentials(valid_params[username], valid_params[password]).session_token).to eq(session[:session_token])
            end
        end

        context "with invalid parameters" do
           
            it "should validate presence of username and password" do 
                post :create, params: invalid_params
                expect(response).to render_template(:new)
                expect(flash[:errors]).to be_present
            end

            it 'validates length of password to be greater than 6 characters' do 
                post :create, params: {user: {username: 'Michelle', password: 'short'} }
                expect(response).to render_template(:new)
                expect(flash[:errors]).to be_present
            end

        end
    end
    
    describe "#edit" do
        it "renders the edit form" do
            get :edit
            expect(response).to render_template(:edit)
        end
    end

    describe "#update" do
        context "with valid parameters" do
            # let(:valid_params) {{ user: {username: "Michael", password: "bluebird"} }}
            # let(:invalid_params) {{ user: {password: "bluebird"} }}
            # let(:user) { User.find_by(username: "Michael") }
            let(:user) {FactoryBot.create(:user, username: "Vanessa", password: "hunter12")}
            
            it "updates user's attributes" do
                patch :update, id: user.id, params: {user: {username: 'Nesstache', password: 'hunter12'} }
                expect(User.find_by(username: "Vanessa")).to be_nil
                expect(User.find_by(id: user.id).username).to eq("Nesstache")
            end
        end

        context "with invalid parameters" do
            let(:user) {FactoryBot.create(:user, username: "Vanessa", password: "hunter12")}

            it "redirects to the edit form" do
                patch :update, id: user.id, params: {user: {username: '', password: 'hunter12'} }
                expect(response).to render_template(:edit)
            end

            it "raises error" do
                expect(flash[:errors]).to be_present
            end
        end
    end
    
    describe "#delete" do
    end
end
