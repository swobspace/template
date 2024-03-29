#
# rails application template
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
# create antora doc tree
#
directory "~/Projects/github/template/template/docs", "docs"
directory "~/Projects/github/template/template/docsrc", "docsrc"

# add some npms
run "yarn add --dev @antora/cli@3.1.0 @antora/site-generator@3.1.0" 
run "yarn add bootstrap@5"
run "yarn add @popperjs/core@2"

run "yarn add jszip"
run "yarn add pdfmake"
run "yarn add datatables.net-bs5"
run "yarn add datatables.net-buttons-bs5"
run "yarn add datatables.net-responsive-bs5"

# run generators
run "bin/rails turbo:install"
run "bin/rails turbo:install:redis"
run "bin/rails css:install:bootstrap"
run "bin/rails javascript:install:esbuild"

generate "rspec:install"
generate "simple_form:install --bootstrap --skip"

generate "wobapphelpers:install"


after_bundle do
  # at last
  # git add: ".", commit: %(-m 'checkin from rails application template')

end
