module TextHelper
  def hbr(target)
    target = html_escape(target)
    target.gsub(/\r\n|\r|\n/, '<br>')
  end

  def markdown(text)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
    markdown.render(text).html_safe
  end
end
