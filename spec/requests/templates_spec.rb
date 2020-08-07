# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Templates', type: :request do
  xdescribe 'Public access to templates' do
    let(:user) { create(:user) }
    let(:user_template) { create(:template, user: user) }

    before :each do
      user_template
    end

    it 'denies access to templates#index' do
      get templates_path

      expect(response).to have_http_status(302)
      expect(response).to redirect_to new_user_session_path
    end

    it 'denies access to templates#new' do
      get new_template_path

      expect(response).to have_http_status(302)
      expect(response).to redirect_to new_user_session_path
    end

    it 'denies access to templates#edit' do
      get edit_template_path(user_template.id)

      expect(response).to have_http_status(302)
      expect(response).to redirect_to new_user_session_path
    end

    it 'denies access to templates#create' do
      template_attributes = build(:template, user: user).attributes

      expect {
        post templates_path(template_attributes)
      }.to_not change(Template, :count)

      expect(response).to have_http_status(302)
      expect(response).to redirect_to new_user_session_path
    end

    it 'denies access to templates#update' do
      patch template_path(user_template, template: user_template.attributes)

      expect(response).to have_http_status(302)
      expect(response).to redirect_to new_user_session_path
    end

    it 'denies access to templates#destroy' do
      delete template_path(user_template)

      expect(response).to have_http_status(302)
      expect(response).to redirect_to new_user_session_path
    end
  end

  xdescribe 'Authenticated access to own templates' do
    let(:user) { create(:user) }
    let(:user_template) { create(:template, user: user) }

    before :each do
      user_template
      sign_in(user)
    end

    it 'renders templates#new' do
      get new_template_path

      expect(response).to be_successful
      expect(response).to render_template(:new)
    end

    it 'renders templates#edit' do
      get edit_template_path(user_template.id)

      expect(response).to be_successful
      expect(response).to render_template(:edit)
    end

    it 'renders templates#create' do
      starting_count = Template.count
      template_attributes = build(:template, user: user).attributes
      post templates_path(template: template_attributes)

      expect(Template.count).to eq(starting_count + 1)
    end

    it 'renders templates#update' do
      new_name = 'different name'
      patch template_path(user_template, template: { name: new_name })

      expect(response).to redirect_to templates_url
    end

    it 'renders templates#destroy' do
      delete template_path(user_template)

      expect(response).to redirect_to(templates_url)
      expect(response.body).to include(templates_url)
    end
  end

  xdescribe "Authenticated access to another user's templates" do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }
    let(:user2_template) { create(:template, user: user2) }

    before :each do
      user2_template
      sign_in(user1)
    end

    it 'denies access to templates#edit' do
      get edit_template_path(user2_template.id)

      expect(response).to_not be_successful
      expect(response).to have_http_status(302)
      expect(response).to redirect_to(root_url)
    end

    it 'denies access to templates#update' do
      new_name = 'completely different name'
      patch template_path(user2_template, template: { name: new_name })

      expect(response).to_not be_successful
      expect(response).to redirect_to root_url
    end

    it 'denies access to templates#destroy' do
      delete template_path(user2_template)

      expect(response).to_not be_successful
      expect(response).to have_http_status(302)
      expect(response).to redirect_to root_url
    end
  end
end
