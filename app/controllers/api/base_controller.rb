module Api
  class BaseController < ApplicationController
    include Api::Concerns::Response
  end
end