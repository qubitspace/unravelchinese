class Word::WordLinkCell < Cell::Concept

  def show
    render :link
  end

  private

  def simplified
    parse_text unless @values.present?
    @values[:simplified]
  end

  def traditional
    parse_text unless @values.present?
    @values[:traditional]
  end

  def pinyin
    parse_text unless @values.present?
    @values[:pinyin]
  end

  def parse_text
    raw_text = model
    @values = {}
    @values[:pinyin] = (raw_text =~ /\<.*\>/) ? raw_text.split('<')[1].sub('>', '') : ''
    raw_text = raw_text.sub("<#{@values[:pinyin]}>", '').split('|')
    @values[:traditional], @values[:simplified] = raw_text.count == 2 ? raw_text : ['', raw_text[0]]
  end

  def raw
    model

  end

  def link display
    #TODO: link to find_or_search word by simplified/traditional/pinyin
      # if there an exact match, use it, otherwise show a results view.
      # might require improvements to the search page.
    #link_to(display, model).html_safe
  end
end
