# template
Base template to generate new rails apps

For a new app:
```
rails new myapp -m /path-to-template/template.rb
```

With an existing app:
```
bin/rails app:template LOCATION=/path-to-template/template.rb
```

See https://guides.rubyonrails.org/generators.html#application-templates

~/.railsrc:
```
--database=postgresql
--skip-test
--skip-jbuilder
--javascript esbuild
--css bootstrap
--template ~/Projects/github/template.rb

```
