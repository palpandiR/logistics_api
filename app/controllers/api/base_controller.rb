module Api
  class BaseController < ApplicationController
    include Api::Concerns::Response
    include Api::Concerns::ErrorHandler
  end
end