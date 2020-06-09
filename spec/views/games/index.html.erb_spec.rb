require 'rails_helper'

RSpec.describe "games/index", type: :view do
  before(:each) do
    assign(:games, [
      Game.create!(
        user: nil
      ),
      Game.create!(
        user: nil
      )
    ])
  end

  it "renders a list of games" do
    render
    assert_select "tr>td", text: nil.to_s, count: 2
  end
end
