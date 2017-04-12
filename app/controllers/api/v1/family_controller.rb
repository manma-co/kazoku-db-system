class Api::V1::FamilyController < Api::V1Controller
  def create

    # Header authorization key
    key = request.authorization
    return json_response 'Invalid auth key length.', :unauthorized unless key.length == 32
    return json_response 'Invalid auth key. Make sure to use correct key.', :unauthorized if key != Rails.application.secrets.auth_key_base

    # Body is inside of request.request_parameters
    body = request.request_parameters
    email = body['email']

    # Validation
    return json_response 'Invalid email.',                        :bad_request if email == nil
    return json_response 'This email is already used',            :bad_request if check_user_exist email
    return json_response 'Sex parameter is required.',            :bad_request if body['sex'] == nil
    return json_response 'First name and last name are required', :bad_request if body['last_name'] == nil || body['first_name'] == nil
    return json_response 'Is family params is required',          :bad_request if body['is_family'] == nil

    @user = User.new(email:      email,
                     tel:        body['tel'],
                     last_name:  body['last_name'],
                     first_name: body['first_name'],
                     kana_first: body['kana_first'],
                     kana_last:  body['kana_last'],
                     sex:        body['sex'].to_i,
                     zip_code1:  body['zip_code1'],
                     zip_code2:  body['zip_code2'],
                     prefecture: body['prefecture'],
                     address1:   body['address1'],
                     address2:   body['address2'],
                     is_family:  body['is_family'],
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
    User.exists?(:email => email)
  end

end