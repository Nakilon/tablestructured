require "maxitest/autorun"

require_relative "lib/tablestructured"
describe TableStructured do

  it "Array" do
    assert_equal \
      [
        {:_1=>4, :"2"=>5, :_2=>6},
        {:_1=>7, :"2"=>8, :_2=>9},
      ],
      TableStructured.new([
        ["",2," "],
        [4,5,6],
        [7,8,9],
      ]).map(&:to_h)
  end

  xit "Oga" do
    require "oga"
    assert_equal(
      {:_1=>"rails", :_2=>"", :_3=>"", :_4=>"", :"Project Score"=>"60.29", :Downloads=>"438,822,072", :Stars=>"52,962", :Forks=>"20,366", :"First release"=>"2004-10-25", :"Latest release"=>"2023-05-24", :"Reverse Dependencies"=>"12,125"},
      TableStructured.new(Oga.parse_html(File.read "test/web_app_frameworks.htm").at_css "table").first.to_h.transform_values(&:text)
    )
  end

end
