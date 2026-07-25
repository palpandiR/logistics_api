module Api
  class BaseController < ApplicationController
    include Api::Concerns::Response
    include Api::Concerns::ErrorHandler
    include Api::Concerns::Authentication

  end
end