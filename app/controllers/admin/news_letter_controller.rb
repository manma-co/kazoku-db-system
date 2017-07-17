class Admin::NewsLetterController < Admin::AdminController

  def index
  end

  def show
  end

  def new
    @news_letter = NewsLetter.new
  end

  def create
    @news_letter = NewsLetter.new(news_letter_params)
    set_right_time
    if @news_letter.save
      redirect_to admin_news_letter_index_path
    end
  end

  def edit
  end

  def update
  end


  private

  def set_right_time
    if @news_letter.distribution.present?
      Time.zone = "Asia/Tokyo"
      @news_letter.distribution = Time.zone.parse(news_letter_params[:distribution]).utc
    end
  end

  def news_letter_params
    params.require(:news_letter).permit(
        :subject,
        :distribution,
        :send_to,
        :content,
        :sent_at,
        :is_save
    )
  end

end
