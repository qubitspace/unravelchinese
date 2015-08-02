require 'rails_helper'

RSpec.describe "attachments/index", type: :view do
  before(:each) do
    assign(:attachments, [
      Attachment.create!(
        :post_id => 1,
        :avatar => "Avatar"
      ),
      Attachment.create!(
        :post_id => 1,
        :avatar => "Avatar"
      )
    ])
  end

  it "renders a list of attachments" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Avatar".to_s, :count => 2
  end
end
