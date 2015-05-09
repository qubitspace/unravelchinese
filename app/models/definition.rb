class Definition < ActiveRecord::Base
  include Taggable
  belongs_to :word

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
end
