class Api::V1::FamilyController < Api::V1Controller
  def create
    @post_data = {
        header: request.authorization,
        body: request.request_parameters
    }
    json_response @post_data
  end
end