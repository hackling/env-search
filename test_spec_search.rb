require_relative "algorithm2.rb"

# describe Page do

#   it "should have keywords" do
#     p1 = Page.new("P1", %w[Review Car])
#     p1.keywords.should eq ['Review', 'Car']
#   end

#   it "should not care about keyword casing" do
#     p1 = Page.new("P1", %w[rEVIEW cAr])
#     p1.keywords.should eq ['Review', 'Car']
#   end
# end

# describe Query do
#     it "it should have keywords" do
#     q1 = Query.new("P1", %w[Review Car])
#     q1.keywords.should eq ['Review', 'Car']
#   end

#   it "should not care about keyword casing" do
#     q1 = Query.new("P1", %w[rEVIEW cAr])
#     q1.keywords.should eq ['Review', 'Car']
#   end
# end

describe Search do 
  let(:max_number) {8}
  let(:search) {Search.new(max_number)}

    it "should detect page input" do
      page = 'P Review'
      search.input(page)
      (search.pages)[0].keywords.should eq ['review']
    end

    it "should detect query input" do
      query = 'Q Review'
      search.input(query)
      (search.queries)[0].keywords.should eq ['review']
    end

    it 'should ignore pages with too many keywords' do
      page = 'P ' + 'Keywords ' * 10
      search.input(page).should eq "Too many keywords in a page"
    end

    it 'should add pages correctly'

    it 'should ignore queries with too many keywords' do
      query = 'Q ' + 'Keywords ' * 10
      search.input(query).should eq "Too many keywords in a query"
    end

    it "should calculate scores correctly"
    it "should not display pages that don't score"
    it "should order pages correctly with same score"
end
