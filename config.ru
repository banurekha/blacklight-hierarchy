require 'rubygems'
require 'bundler'
require 'blacklight/engine'
require 'rails'
require 'rsolr'
require 'rsolr-ext'
Bundler.require :default, :development

Combustion.initialize! :active_record, :action_controller,
                       :action_view, :sprockets, :action_mailer
run Combustion::Application
