class Sentence < ActiveRecord::Base
  belongs_to :article
  has_many :tokens, dependent: :destroy
  has_many :translations, -> { order('cached_votes_score desc') }, dependent: :destroy
  has_many :words, through: :tokens

  accepts_nested_attributes_for :translations, :reject_if => lambda { |t| t[:value].blank? }

  before_create :set_rank
  before_create :translate, on: :create

  attr_accessor :untokenized
  attr_accessor :tokenized

  protected

  # Put each translation in a try block so it will ignore failed translations (with retries)
  def translate
    self.translations.destroy
    google_translate # free trial expire on 4/4
    bing_translate
    #dictionary_translate # this is just bing
  end

  def dictionary_translate
    source = Source.find_or_create_by name: "Dictionary.com", link: "http://translate.reference.com/"

    url = "http://translate.reference.com/chinese-simplified/english/#{self.value}"
    response = Typhoeus.get(url, followlocation: true)
    doc = Nokogiri::HTML(response.body)
    translation = doc.css('#clipboard-text').first.text
    self.translations.build value: translation, source: source
  end

  def google_translate
    source = Source.find_or_create_by name: "Google Translate", link: "www.google.com"

    config = {
      :method => :get,
      :ssl_verifypeer => false,
      :params => {
        :key => 'AIzaSyBRUU9XnvPN3yeTMF5Phiage98UZFom6IQ',
        :target => 'en',
        :source => 'zh-CN',
        :q => self.value
      }
    }

    request = Typhoeus::Request.new("https://www.googleapis.com/language/translate/v2/", config)
    request.run

    response_body = JSON.parse(request.response.body)

    response_body['data']['translations'].each do |translation|
      self.translations.build value: translation['translatedText'], source: source
    end

  end

  def get_bing_access_token

    auth_url = "https://datamarket.accesscontrol.windows.net/v2/OAuth2-13"

    request_config = {
      :body => "client_id=unravelchinese&client_secret=LYF6kN0SSHlcULW1wo0%2FXGkniyy5NyV0U%2F6d0hJBDZM%3D&scope=http%3A%2F%2Fapi.microsofttranslator.com&grant_type=client_credentials",
      :method => :post,
      :headers => { :'content-type' => 'application/x-www-form-urlencoded' },
      :params => {},
      :ssl_verifypeer => false
    }

    request = Typhoeus::Request.new(auth_url, request_config)
    request.run

    result = JSON.parse(request.response.body)
    result['access_token']
  end

  def bing_translate
    source = Source.find_or_create_by name: "Bing Translate", link: "www.bing.com"
    access_token = get_bing_access_token

    translate_url = "http://api.microsofttranslator.com/v2/Http.svc/Translate"

    headers = { :Authorization => "Bearer #{access_token}" }

    text = self.value
    from = "zh-CHS"
    to = "en"

    params = {
      :appId => '',
      :text => text,
      :to => to,
      :from => from,
      :contentType => 'text/plain'
    }

    request_config = {
      :method => :get,
      :headers => headers,
      :params => params,
      :ssl_verifypeer => false
    }

    request = Typhoeus::Request.new(translate_url, request_config)
    request.run

    doc = Nokogiri::XML(request.response.body)
    self.translations.build value: doc.root.text, source: source
  end

  def set_rank
    self.rank = if Sentence.where(article_id: self.article_id).count > 0
                then Sentence.where(article_id: self.article_id).maximum(:rank) + 1
                else 0
                end
  end
end



