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
    @address = params[:address]
    family_list = family_params
    if params[:address].present?
      geocoder = Geocoder.search(params[:address])
      @search_result_address = geocoder[0].formatted_address
      location = geocoder[0].geometry['location']
      @candidate_hash = Location.candidate_list(location, family_list)
    end
  end

  private

  def family_params
    # 働き方のステータス
    @job_style = params[:job_style] || Settings.job_style.none
    @job_style = @job_style.to_i
    if @job_style == Settings.job_style.both
      job_style = [Settings.job_style.both, Settings.job_style.both_single]  # シングルも含む
      family = ProfileFamily.where(job_style: job_style)
    elsif @job_style == Settings.job_style.homemaker
      job_style = Settings.job_style.homemaker
      family = ProfileFamily.where(job_style: job_style)
    else
      family = ProfileFamily.all
    end

    # 男性NGかどうか
    @is_male_ng = params[:is_male_ng].nil? ? false : true
    if params[:is_male_ng].nil?
      family ||= ProfileFamily.all
    else
      family = family.where(is_male_ok: !@is_male_ng)
    end
    family
  end

end
