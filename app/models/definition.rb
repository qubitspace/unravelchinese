class Definition < ActiveRecord::Base
  belongs_to :word


  #Might be useful for parsing the definition links.
  #key = key.to_s.gsub(/\[(\d+)\]/, '.\1')

  def html_value
    result = value.sub /^CL\:/, '<b>Classifiers:</b> '
    result.gsub /\[\[(.*?)\]\]/ do |reference|
      values = $1
      pinyin = (values =~ /\<.*\>/) ? values.split('<')[1].sub('>', '') : ''
      values = values.sub("<#{pinyin}>", '').split('|')
      traditional, simplified = values.count == 2 ? values : ['', values[0]]
      "<span class='definition_link'><a href='/dictionary/find?simplified=#{simplified}&traditional=#{traditional}&pinyin=#{pinyin}'>#{simplified}#{'('+pinyin+')' if pinyin}</a></span>"
    end
  end

  def set_rank word, rank

    if rank.present?
      self.rank = rank
      shift_definitions = word.definitions.where( "rank > ?", rank).order( 'rank desc')
      shift_definitions.each do |definition|
        definition.rank += 1
        definition.save
      end
    else
      self.rank = if word.definitions.count > 0
                then word.definitions.maximum(:rank) + 1
                else 0
                end
    end

  end
end


