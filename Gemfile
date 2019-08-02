source 'https://rubygems.org'

# git_source(:github) { |repo_name| 'https://github.com/#{repo_name}.git' }

branch = ENV.fetch('SOLIDUS_BRANCH', 'master')
gem 'solidus', github: 'geminimvp/solidus', branch: 'gemini_master_v271'
gem 'solidus_auth_devise', '~> 1.0'

# if branch == 'master' || branch >= 'v2.3'
#   gem 'rails', '>= 5.1.0'
# elsif branch >= 'v2.0'
#   gem 'rails', '~> 5.0.0'
# end
gem 'rails', '5.2.3'

# gem 'mysql2', '~> 0.4.10'
gem 'pg', '~> 0.21'

group :test do
  if branch == 'master' || branch >= 'v2.0'
    gem 'rails-controller-testing'
  else
    gem 'rails_test_params_backport'
  end

  if branch < 'v2.5'
    gem 'factory_bot', '4.10.0'
  else
    gem 'factory_bot', '> 4.10.0'
  end
end

group :development, :test do
  gem 'i18n-tasks', '~> 0.9' if branch == 'master'
  gem 'byebug'
  gem 'pry-rails'
end

gemspec
