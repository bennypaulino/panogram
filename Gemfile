source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.0', '>= 5.0.0.1'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'

# jQuery plugin for drop-in fix binded events problem caused by Turbolinks
gem 'jquery-turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'

# Extends ActiveRecord w/ support for organizing parent–children relationships
gem 'acts_as_tree'

# Converts Less to Sass and make Bootstrap available
gem 'bootstrap-sass', '3.3.6'

# Jquery-based component library, used to style the file fields of forms
gem 'bootstrap-filestyle-rails'

# Create pagination links
gem 'will_paginate', '~> 3.1.0'

# Configure will_paginate to use Bootstrap's pagination styles
gem 'bootstrap-will_paginate', '~> 0.0.10'

# has_secure_password uses a state-of-the-art hash function inside...
gem 'bcrypt', '~> 3.1.11'

# Provides a simple & flexible way to upload files from Ruby applications.
gem 'carrierwave', '~> 0.11.2'

# Minimagick helps to manipulate images with minimal use of memory via ImageMagick
gem 'mini_magick', '~> 4.5.1'

# Handles both server cloud & storage based services. Supports Amazon S3 & more.
gem 'fog', '~> 1.38.0'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri

  # Generate sample users with semi-realistic names and email addresses
  gem 'faker', '~> 1.6.3'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'rails-controller-testing', '0.1.1'
  gem 'minitest-reporters',       '1.1.9'
  gem 'guard',                    '2.13.0'
  gem 'guard-minitest',           '2.4.4'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
