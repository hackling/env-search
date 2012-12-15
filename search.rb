  Page = Struct.new(:keywords, :score)

  Query = Struct.new(:keywords)


class Search
  attr_accessor :pages, :queries

  def initialize max_number = 8
    @max_number_of_keywords = max_number
    @pages = []
    @queries = []
  end

  def input data
    data = data.split(" ")
    print data
    
    case data[0]
    when 'P'
      add_page(data.slice(1..-1))
    when 'Q'
      add_query(data.slice(1..-1))
    else
      "Incorrect input statement"
    end
  end

  def downcase_array arr
    arr_temp = []
    arr.each {|value| arr_temp << value.downcase}
    arr_temp
  end

  def add_page data
    if size_validation(data)
      self.pages << Page.new(downcase_array(data))
    else
      "Too many keywords in a page"
    end
  end

  def add_query query
    if size_validation(query)
      @queries << Query.new(downcase_array(query)) 
    else
      "Too many keywords in a query"
    end
  end

  def size_validation arr
    arr.size < @max_number_of_keywords 
  end

end


#p1 = Page.new("P1", %w[Review Car])


