class Admin::NewsLetterController < Admin::AdminController

  before_action :set_news_letter, only:[:show, :edit, :update]

  add_template_helper(TextHelper)

  def index
    @monthly_news_letter = NewsLetter.
        where('distribution <= ? AND is_save = ?', Time.now, false).
        where('is_monthly = ? ', true).
        where('send_to = ?', 'participant').first
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
    respond_to do |format|
      if @news_letter.update(news_letter_params)
        format.html { redirect_to admin_news_letter_path(@news_letter), notice: 'News letter was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end


  private

  def set_news_letter
    @news_letter = NewsLetter.find(params[:id])
  end
  
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
        :is_save,
        :is_monthly,
    )
  end

end
