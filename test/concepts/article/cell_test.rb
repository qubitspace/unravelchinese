require 'test_helper'

class ArticleCellTest < Cell::TestCase
  controller ArticlesController

  let(:rails) { Article::Create[article: {title: "Rails", link: "www.rails.org"}] }
  let(:trb) { Article::Create[article: {title: "Trailblazer", link: "www.trailblazer.org"}] }

  subject { concept("article/cell", collection: [trb, rails], last: rails) }

  it do
    #subject.must_have_selector ".columns .header a", text: "Rails"
    #subject.must_not_have_selector ".columns.end .header a", text: "Rails"
    #subject.must_have_selector ".columns.end .header a", text: "Trailblazer"
  end

end