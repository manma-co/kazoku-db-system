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
    return unless params[:address].present?

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
      # Google API error: over query limit. 対策
      @search_result_address = "エラーが発生しました。全件表示します。エラー内容: #{e}"
      locations = family_list.map { |f| [f.user.location, 0] }
      @candidate_hash = Hash[*locations.flatten]
    end
  end

  private

  def family_params
    # 働き方のステータス
    @job_style = params[:job_style] || Settings.job_style.none
    @job_style = @job_style.to_i
    if @job_style == Settings.job_style.both
      job_style = [Settings.job_style.both, Settings.job_style.both_single] # シングルも含む
      family = ProfileFamily.where(job_style: job_style)
    elsif @job_style == Settings.job_style.homemaker
      job_style = Settings.job_style.homemaker
      family = ProfileFamily.where(job_style: job_style)
    else
      family = ProfileFamily.all
    end

    # 男性NGかどうか
    @is_male_ok = params[:is_male_ok].nil? ? false : true
    if params[:is_male_ok].nil?
      family ||= ProfileFamily.all
    else
      family = family.where(is_male_ok: @is_male_ok)
    end
    family.includes(user: [:location, :contact, { reply_log: { request_log: :email_queue } }])
  end

end
