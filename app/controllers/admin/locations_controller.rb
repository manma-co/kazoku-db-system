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
    @job_style = params[:job_style] || 'none'
    # 男性NGかどうか
    if params[:is_male_ng].nil?
      @is_male_ng = false
    else
      @is_male_ng = true
    end

    # TODO: refactoring
    # 働き方ステータスによってクエリを変更する
    job_style = nil
    if @job_style == 'dual'
      job_style = 1
    elsif @job_style == 'single'
      job_style = 2
    end

    if job_style.nil?
      ProfileFamily.where(is_male_ok: !@is_male_ng)
    else
      ProfileFamily.where(is_male_ok: !@is_male_ng, job_style: job_style)
    end
  end

end
