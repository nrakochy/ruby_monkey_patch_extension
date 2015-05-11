module ArrHelpers

  class ::Array
    def where(contained_hash_obj)
      arg_arr = contained_hash_obj.to_a
      select_by_args(arg_arr)
    end

    private

    def select_by_args(arg_arr)
      search_set = arg_arr.shift
      search_key = search_set.first
      search_value = convert_to_regexp(search_set.last)
      selection = self.select! do |item|
        item_value = item[search_key]
        search_value.match(item_value.to_s)
      end
      return selection if arg_arr.count == 0
      select_by_args(arg_arr)
    end

    def convert_to_regexp(search)
      search.class != Regexp ? Regexp.new(search.to_s) : search
    end
  end

end

require 'test/unit'

class WhereTest < Test::Unit::TestCase
  extend ArrHelpers

  def setup
    @boris   = {:name => 'Boris The Blade', :quote => "Heavy is good. Heavy is reliable. If it doesn't work you can always hit them.", :title => 'Snatch', :rank => 4}
    @charles = {:name => 'Charles De Mar', :quote => 'Go that way, really fast. If something gets in your way, turn.', :title => 'Better Off Dead', :rank => 3}
    @wolf    = {:name => 'The Wolf', :quote => 'I think fast, I talk fast and I need you guys to act fast if you wanna get out of this', :title => 'Pulp Fiction', :rank => 4}
    @glen    = {:name => 'Glengarry Glen Ross', :quote => "Put. That coffee. Down. Coffee is for closers only.",  :title => "Blake", :rank => 5}
    @fixtures = [@boris, @charles, @wolf, @glen]
  end

  def test_where_with_exact_match
    assert_equal [@wolf], @fixtures.where(:name => 'The Wolf')
  end

  def test_where_with_partial_match
    assert_equal [@charles, @glen], @fixtures.where(:title => /^B.*/)
  end

  def test_where_with_mutliple_exact_results
    assert_equal [@boris, @wolf], @fixtures.where(:rank => 4)
  end

  def test_with_with_multiple_criteria
    assert_equal [@wolf], @fixtures.where(:rank => 4, :quote => /get/)
  end

  def test_with_chain_calls
    assert_equal [@charles], @fixtures.where(:quote => /if/i).where(:rank => 3)
  end
end

