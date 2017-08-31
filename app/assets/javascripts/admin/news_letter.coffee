# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
  $('.tab_wrap .preview').on 'click', (event) ->
    # なぜかわからないけど、console log がないとプレビュー表示が失敗する。
    console.log("Showing preview...");
    event.preventDefault()
    url = '/admin/news_letters/preview'
    $.ajax(
      url: url,
      type: 'post',
      data:
        news_letter:
          content: $('#news_letter_content').val()
    )

    $('.back-to-input').on 'click', (e) ->
      e.preventDefault()
      $('.text-preview').html('')
      $('.text-input').show()
      $('.tab_wrap li').addClass('active')
      $('.tab_wrap li.tab2').removeClass('active')

# For turbolinks
$(document).ready(ready)
$(document).on 'page:load', ready