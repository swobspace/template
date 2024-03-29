# rails application template
# run 'bundle remove tzinfo-data'
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
      g.test_framework    nil
      g.jbuilder          false
    end
  CODE
end

#
# create antora doc tree
#
directory "~/Projects/github/template/template/docs", "docs"
directory "~/Projects/github/template/template/docsrc", "docsrc"

run "yarn add --dev @antora/cli@3.1.0 @antora/site-generator@3.1.0" 

after_bundle do
  # at last
  # git add: ".", commit: %(-m 'checkin from rails application template')

end
