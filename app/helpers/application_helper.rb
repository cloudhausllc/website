module ApplicationHelper
  # ==== Examples
  # glyph(:share_alt)
  # # => <i class="icon-share-alt"></i>
  # glyph(:lock, :white)
  # # => <i class="icon-lock icon-white"></i>

  def glyph(*names)
    content_tag :span, nil, class: names.map { |name| "glyphicon glyphicon-#{name.to_s.gsub('_', '-')}" }
  end
end


