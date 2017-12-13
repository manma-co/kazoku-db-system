class Admin::NewsLetterController < Admin::AdminController

  before_action :set_news_letter, only:[:show, :edit, :update]

  add_template_helper(TextHelper)

  def index
    @monthly_news_letter = NewsLetter.
        where('is_save = ?', false).
        where('is_monthly = ? ', true).
        where('send_to = ?', 'participant').first

    @news_letters = NewsLetter.
        where('is_save = ? AND is_sent = ?', false, false).
        where('is_monthly = ? ', false)

    @news_saved = NewsLetter.where(is_save: true)
  end

  def show
  end

  def new
    @news_letter = NewsLetter.new
  end

  def create
    @news_letter = NewsLetter.new(news_letter_params)
    @news_letter.is_monthly ? set_as_next_month : set_right_time

    respond_to do |format|
      if @news_letter.save
        format.html { redirect_to admin_news_letter_index_path, notice: 'News letter was successfully created.' }
      else
        format.html { render :new }
      end
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


  def history
    @monthly_news_letter = NewsLetter.
        where('is_save = ?', false).
        where('is_monthly = ? ', true).
        where('send_to = ?', 'participant')

    @news_letter = NewsLetter.
        where('distribution <= ? AND is_save = ? AND is_sent = ?', Time.now, false, true).
        where('is_monthly = ? ', false).
        where('send_to = ?', 'family')
  end

  def preview
    @body = news_letter_params[:content]
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

  def set_as_next_month
    @news_letter.distribution = Time.zone.parse(Time.now.next_month.beginning_of_month.strftime("%Y/%m/%d")).utc
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
