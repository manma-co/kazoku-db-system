class Admin::LocationsController < Admin::AdminController
  protect_from_forgery except: :create

  def index
    @locations = Location.all
  end

  def create
    location = Location.new(location_params)
    location.save
    render json: {}, status: :ok
  end

  def location_params
    params.require(:family).permit(:address)
  end

  def search
    return if params[:address].blank?

    @address = params[:address]
    family_list = family_params
    begin
      Geocoder.configure(
        lookup: :google,
        api_key: ENV['GOOGLE_GEOCODER_API_KEY']
      )
      geocoder = Geocoder.search(params[:address])

      raise('地点が見つかりませんでした。') if geocoder.blank?

      @search_result_address = geocoder[0].formatted_address
      location = geocoder[0].geometry['location']
      @candidate_hash = Location.candidate_list(location, family_list)
    rescue Exception => e
      Raven.capture_exception(e)
      # Google API error: over query limit. 対策
      @search_result_address = "エラーが発生しました。全件表示します。エラー内容: #{e}"
      locations = family_list.map { |f| [f.user.location, 0] }
      @candidate_hash = Hash[*locations.flatten]
    end
  end

  private

  def family_params
    Location.joins(:user).includes(user: [:location, :contact, { study_abroad_request: { study_abroad: :email_queue } }])
  end
end
