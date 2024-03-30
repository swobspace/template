#
# rails application template
#
require 'securerandom'
@postgresql_user_password = SecureRandom.base64(32)
@secret_key_base = SecureRandom.hex(128)
#
run 'bundle remove tzinfo-data'
append_to_file 'Gemfile' do
  <<~GEMS

  # --- TEMPLATE START ---
  gem 'simple_form'
  gem 'wobapphelpers', git: 'https://github.com/swobspace/wobapphelpers', 
                     branch: 'master'
  gem 'rails-i18n', '~> 7.0.0'
  gem 'font-awesome-sass', '~> 6.0'
  gem 'view_component'
  gem 'cancancan'
  gem "wobauth", git: "https://github.com/swobspace/wobauth.git", branch: "master"

  group :test, :development do
    gem 'rspec-rails'
    gem 'dotenv'
    # gem 'json_spec', require: false
  end

  group :test do
    gem "shoulda-matchers", require: false
    gem 'factory_bot_rails'
    gem "capybara"
    gem 'selenium-webdriver'
    gem 'webdriver'
    gem 'launchy'
  end
  # --- TEMPLATE END ---
  GEMS
end

run "bundle install"

inject_into_file 'config/application.rb', before: '  end' do
  <<-CODE
    config.generators do |g|
      g.assets            false
      g.helper            false
      g.test_framework    :rspec
      g.jbuilder          false
    end
  CODE
end

#
# copying templates
#
directory "~/Projects/github/template/template/docs", "docs"
directory "~/Projects/github/template/template/docsrc", "docsrc"
directory "~/Projects/github/template/template/app", "app"
directory "~/Projects/github/template/template/config", "config"
directory "~/Projects/github/template/template/ansible", "ansible"
template "~/Projects/github/template/template/.env.development.local.tt", ".env.development.local"

# add some npms
run "yarn add --dev @antora/cli@3.1.0 @antora/site-generator@3.1.0" 
run "yarn add bootstrap@5"
run "yarn add @popperjs/core@2"
run "yarn add @hotwire/stimulus"

run "yarn add jszip"
run "yarn add pdfmake"
run "yarn add datatables.net-bs5"
run "yarn add datatables.net-buttons-bs5"
run "yarn add datatables.net-responsive-bs5"
run "yarn add sass"

run "nvm install nodemon -g"

# run generators
run "bin/rails turbo:install"
run "bin/rails turbo:install:redis"
run "bin/rails css:install:bootstrap"
run "bin/rails javascript:install:esbuild"
run "bin/rails stimulus:install"

generate "rspec:install"
generate "simple_form:install --bootstrap --skip"

generate "wobapphelpers:install"

# wobauth
generate "cancan:ability"

create_file 'app/models/wobauth/user.rb' do <<~WOBAUTHUSER
  require_dependency 'wobauth/concerns/models/user_concerns'
  class Wobauth::User < ActiveRecord::Base
    # dependencies within wobauth models
    include UserConcerns

    # devise *#{app_name}.devise_modules 
    # or ... basic usage:
    devise :database_authenticatable

    validates :password, confirmation: true
  end

  WOBAUTHUSER
end

generate "wobauth:install"
run "bin/rake wobauth:install:migrations"

create_file 'config/initializers/locales.rb' do <<~LOCALES
  Rails.application.config.i18n.available_locales = [:de, :en]
  Rails.application.config.i18n.default_locale = :de
  Rails.application.config.time_zone = 'Berlin'
  LOCALES
end

create_file "config/locales/#{app_name}.de.yml" do <<-MYLOCALE
de:
  activerecord:
    models:
      user: User

  attributes:
    description: Beschreibung
    displayname: Anzeigename
    givenname: Vorname
    name: Name
    sn: Nachname
    username: Username

  controller:
    users: Benutzer
MYLOCALE
end

insert_into_file 'app/controllers/application_controller.rb', after: "class ApplicationController < ActionController::Base\n" do <<-APPCONTROLLER
  # -- breadcrumbs
  include Wobapphelpers::Breadcrumbs
  before_action :add_breadcrumb_index, only: [:index]
  # before_action :set_paper_trail_whodunnit

  # -- flash responder
  self.responder = Wobapphelpers::Responders
  respond_to :html, :json, :js

  helper_method :add_breadcrumb
  protect_from_forgery prepend: true
APPCONTROLLER
end

insert_into_file 'app/helpers/application_helper.rb', after: "module ApplicationHelper\n" do <<-APPHELPER
  include Wobapphelpers::Helpers::All
APPHELPER
end

after_bundle do
  # at last
  # git add: ".", commit: %(-m 'checkin from rails application template')

end
