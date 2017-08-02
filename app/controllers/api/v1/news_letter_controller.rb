class Api::V1::NewsLetterController < Api::V1Controller
  def test_mail
    # Body is inside of request.request_parameters
    body = request.request_parameters

    # Set params
    news_id = body["news_id"]
    address = body["address"]

    news = NewsLetter.find(news_id)

    if news.id < 1
      @info = {error: "Invalid id"}
      json_response @info
      return
    end

    NewsLetterMailer.send_news_letter(news, address).deliver_now

    @info = {success: "Mail sent"}
    json_response @info
  end
end