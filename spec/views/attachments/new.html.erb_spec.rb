require 'rails_helper'

RSpec.describe "attachments/new", type: :view do
  before(:each) do
    assign(:attachment, Attachment.new(
      :post_id => 1,
      :avatar => "MyString"
    ))
  end

  it "renders new attachment form" do
    render

    assert_select "form[action=?][method=?]", attachments_path, "post" do

      assert_select "input#attachment_post_id[name=?]", "attachment[post_id]"

      assert_select "input#attachment_avatar[name=?]", "attachment[avatar]"
    end
  end
end
