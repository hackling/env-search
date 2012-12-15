require "search.rb"

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

    it 'should ignore queries with too many keywords' do
      query = 'Q ' + 'Keywords ' * 10
      search.input(query).should eq "Too many keywords in a query"
    end

    it "should calculate scores correctly" do
      p1 = Page.new( %w[one two three] )
      q1 = Query.new(['one'])
      score = search.calculate_score q1, p1
      score.should eq (max_number * max_number)    
    end

    it "should calculate multiple scores correctly" do
      p1 = Page.new( %w[one two three] )
      q1 = Query.new( %w[one two three] )
      score = search.calculate_score q1, p1
      x = max_number
      result = (x*x)
      result += (x-1)*(x-1)
      result += (x-2)*(x-2)
      score.should eq result  
    end

    it "should calculate multiple scores correctly mixed up" do
      p1 = Page.new( %w[three one two] )
      q1 = Query.new( %w[one two three] )
      score = search.calculate_score q1, p1
      x = max_number
      result = x*(x-1)
      result += (x-1)*(x-2)
      result += (x-2)*(x)
      score.should eq result  
    end

    it "should not display pages that don't score" do
      search.input('Q one two three')
      search.input('P one')
      search.input('P two')
      search.input('P one three')
      search.input('P four')
      search.calculate_all_scores
    end

    it "should order pages correctly with same score" do

      arr = []
      (1..3).each do |x|
        arr << Score.new(max_number*max_number,x)
      end

      result = search.output_scores arr, 1
      result.should eq "Q1: P1 P2 P3"    
    end

    it "should not care about casing" do
      search.add_page(%w[TesT])
      search.add_query(%w[tESt])
      score = search.calculate_score search.queries[0], search.pages[0] 
      score.should eq (max_number * max_number)
    end

    it "should not score with no data" do
      search.calculate_all_scores.should eq "No Data"
    end

    it "should handle multiple queries" do
      search.input 'P one'
      search.input 'Q one'
      search.input 'Q one'
      output = search.calculate_all_scores
      output.should eq "Q1: P1\nQ2: P1\n"
    end

    it "should handle multiple pages and multiple queries" do
      search.input 'P one'
      search.input 'P one'
      search.input 'Q one'
      search.input 'Q one'
      output = search.calculate_all_scores
      output.should eq "Q1: P1 P2\nQ2: P1 P2\n"
    end
end
