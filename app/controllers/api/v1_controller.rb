class Api::V1Controller < ActionController::API
  include Response

  def index
    @info = {
      version: 'v1'
    }
    json_response @info
  end
end
