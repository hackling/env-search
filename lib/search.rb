module StringMethods
  def downcase_array arr
    arr_temp = []
    arr.each {|value| arr_temp << value.downcase}
    arr_temp
  end
end

class Page
  attr_reader :keywords

  include StringMethods

  def initialize data
    @keywords = downcase_array(data)
  end
end

class Query
  attr_reader :keywords

  include StringMethods

  def initialize data
    @keywords = downcase_array(data)
  end
end

class Score
  attr_accessor :score, :page
  
  def initialize score, page
    @score = score
    @page = page
  end

  def <=> other
    a = self.score <=> other.score
    return a unless a == 0
    return other.page <=> self.page 
  end
end



class Search
  attr_accessor :pages, :queries

  def initialize max_number = 8
    @max_number_of_keywords = max_number
    @pages = []
    @queries = []
  end

  def input data
    data = data.split(" ")    
    case data[0]
    when 'P'
      add_page(data.slice(1..-1))
    when 'Q'
      add_query(data.slice(1..-1))
    else
      "Incorrect input statement"
    end
  end

  def add_page data
    if valid_size?(data)
      @pages << Page.new(data)
    else
      "Too many keywords in a page"
    end
  end

  def add_query query
    if valid_size?(query)
      @queries << Query.new(query)
    else
      "Too many keywords in a query"
    end
  end

  def valid_size? arr
    arr.size < @max_number_of_keywords
  end

  def calculate_all_scores
    output = ""
    if !@queries.empty? && !@pages.empty?
      @queries.each_with_index do |query, query_index|
        arr = []
        @pages.each_with_index do |page, page_index|
          score = calculate_score query, page
          arr << Score.new(score, page_index+1)
        end
        output += "#{(output_scores arr, query_index+1)}\n"
      end
      output
    else
      "No Data"
    end 
  end

  def calculate_score query, page
    common_keywords = page.keywords & query.keywords
    score = 0
    common_keywords.each do |keyword|
      page_weighting = @max_number_of_keywords - page.keywords.index(keyword)
      query_weighting = @max_number_of_keywords - query.keywords.index(keyword)
      score += page_weighting * query_weighting
    end
    score
  end

  def output_scores arr, query_index
    max = 5
    output = "Q#{query_index}: "
     arr.sort.reverse[0..max-1].each do |score|
      if score.score != 0
        output += "P#{score.page} "
      end
    end
    output.strip
  end
end
