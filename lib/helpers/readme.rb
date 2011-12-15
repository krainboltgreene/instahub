module ReadmeHelper
  def readmeify(page)
    Nokogiri::HTML(page).css('#readme .wikistyle').inner_html
  end
end
