module TextHelper
  def hbr(target)
    target = html_escape(target)
    target.gsub(/\r\n|\r|\n/, "<br />")
  end
end