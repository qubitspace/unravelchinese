require 'trailblazer/operation'
require 'trailblazer/operation/responder'
require 'trailblazer/operation/representer'
require 'trailblazer/operation/controller'
require 'reform/form/json'

# require "roar/json"
# require 'roar/json/hal'

require 'trailblazer/autoloading'


# I extend the CRUD module here to make it also include CRUD::ActiveModel globally. This is my choice as the
# application architect. Don't do it if you don't use ActiveModel form builders/models.
Trailblazer::Operation::CRUD.module_eval do
  module Included
    def included(base)
      super # the original CRUD::included method.
      base.send :include, Trailblazer::Operation::CRUD::ActiveModel
    end
  end
  extend Included # override CRUD::included.
end