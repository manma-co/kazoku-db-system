class Api::V1::FamilyController < Api::V1Controller
  def create

    # Header authorization key
    key = request.authorization
    return json_response 'Invalid auth key length.', :unauthorized unless key.length == 32
    return json_response 'Invalid auth key. Make sure to use correct key.', :unauthorized if key != Rails.application.secrets.auth_key_base

    # Body is inside of request.request_parameters
    body = request.request_parameters
    email = body['email_pc']

    # Validation
    return json_response 'Invalid email.',                        :bad_request if email == nil
    return json_response 'This email is already used',            :bad_request if check_user_exist email
    return json_response 'Sex parameter is required.',            :bad_request if body['sex'] == nil
    return json_response 'Name is required',                      :bad_request if body['name'] == nil
    return json_response 'Is family params is required',          :bad_request if body['is_family'] == nil

    @user = User.new(email_pc:      email,
                     email_phone:   body['email_phone'],
                     tel:           body['tel'],
                     name:          body['name'],
                     kana:          body['kana'],
                     sex:           body['sex'].to_i,
                     address:       body['address'],
                     is_family:     body['is_family'],
    )

    # Save user.
    if @user.save
      json_response @user, :created
    else
      json_response @user.errors, :unprocessable_entity
    end

  end

  private

  def check_user_exist(email)
    User.exists?(:email_pc => email)
  end

end