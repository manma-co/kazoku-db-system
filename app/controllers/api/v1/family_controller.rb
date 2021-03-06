class Api::V1::FamilyController < Api::V1Controller
  # To create new user data.
  def create
    # Header authorization key
    key = request.authorization

    # Auth validation
    unless key.length == 32
      return json_response 'Invalid auth key length.', :unauthorized
    end
    if key != ENV['AUTH_KEY_BASE']
      return json_response 'Invalid auth key. Make sure to use correct key.', :unauthorized
    end

    # Body is inside of request.request_parameters
    body = request.request_parameters

    # Set parameter
    email             = body['email_pc']
    gender            = body['gender']
    name              = body['name']
    is_family         = body['is_family']
    job_style         = body['job_style']
    birthday_mother   = body['birthday_mother']
    birthday_father   = body['birthday_father']
    is_photo_ok       = body['is_photo_ok']
    is_sns_ok         = body['is_sns_ok']
    is_male_ok        = body['is_male_ok']

    # Validation
    if email.nil?
      return json_response 'Invalid email.',                  :bad_request
    end
    if check_user_exist email
      return json_response 'This email is already used',      :bad_request
    end
    if gender.nil?
      return json_response 'Gender parameter is required.',   :bad_request
    end
    if name.nil?
      return json_response 'Name is required',                :bad_request
    end
    if is_family.nil?
      return json_response 'Is family params is required',    :bad_request
    end
    if job_style.nil?
      return json_response 'Job style params is required',    :bad_request
    end
    if birthday_mother.nil? || birthday_father.nil?
      return json_response 'Birthday is required',            :bad_request
    end
    if is_photo_ok.nil?
      return json_response 'Is_photo_ok is required',         :bad_request
    end
    if is_sns_ok.nil?
      return json_response 'is_sns_ok is required',           :bad_request
    end
    if is_male_ok.nil?
      return json_response 'is_male_ok is required',          :bad_request
    end

    user = User.new(
      name: name,
      kana: body['kana'],
      gender: gender.to_i,
      is_family: is_family
    )

    profile_family = user.build_profile_family(
      job_style: job_style,
      number_of_children: body['number_of_children'],
      is_photo_ok: is_photo_ok,
      is_sns_ok: is_sns_ok,
      is_male_ok: is_male_ok
    )

    profile_mother = profile_family.profile_individuals.build(
      birthday: birthday_mother,
      job_domain: body['job_domain_mother'],
      role: 'mother'
    )
    profile_father = profile_family.profile_individuals.build(
      birthday: birthday_father,
      job_domain: body['job_domain_father'],
      role: 'father'
    )

    contact = user.build_contact(
      email_pc: email,
      email_phone: body['email_phone']
    )

    location = user.build_location(
      address: body['address']
    )

    # Save user.
    if user.save && profile_family.save && profile_mother.save &&
       profile_father.save && contact.save && location.save
      data = {
        user: user,
        location: location,
        contact: contact,
        family: profile_family,
        mother: profile_mother,
        father: profile_father
      }
      json_response data, :created
    else
      json_response user.errors, :unprocessable_entity
    end
  end

  private

  def check_user_exist(email)
    Contact.exists?(email_pc: email)
  end
end
