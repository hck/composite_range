class CompositeRange
  include Enumerable

  attr_accessor :ranges

  def initialize(args = [], options={})
    unless options[:exclude]
      @ranges = args.is_a?(Array) ? args : [args]
      return
    end

    options[:exclude] = [options[:exclude]] unless options[:exclude].is_a? Array

    @ranges = options[:exclude].inject([args]) do |res, r|
      res.map do |range|
        if range.include?(r.begin) and range.include?(r.end)
          val = []
          val << (range.begin..r.begin) if range.begin != r.begin
          val << (r.end..range.end) if range.end != r.end
          val
        elsif range.include?(r.begin)
          (range.begin..r.begin) if range.begin != r.begin
        elsif range.include?(r.end)
          (r.end..range.end) if range.end != r.end
        else
          range
        end
      end.flatten.compact
    end
  end

  def ==(obj)
    obj.respond_to?(:ranges) ? self.ranges == obj.ranges : self.ranges == obj
  end

  def eql?(obj)
    obj.is_a?(self.class) and self == obj
  end

  def [](key)
    @ranges[key]
  end

  def []=(val)
    if val.is_a?(::Range) or val.is_a?(self.class)
      @ranges << val
    else
      raise 'Only arguments with class Range or CompositeRange allowed'
    end
  end

  def <<(val)
    if val.is_a?(::Range) or val.is_a?(self.class)
      @ranges.push(val)
    else
      raise 'Only arguments with class Range or CompositeRange allowed'
    end
  end

  def each(&block)
    @ranges.each(&block)
  end

  def cover?(val)
    select_ranges{|r| r.cover?(val)}.size > 0
  end

  def include?(val)
    select_ranges{|r| r.include?(val)}.size > 0
  end
  alias :member? :include?
  alias :=== :include?

  def begin
    ranges.min_by{|r| r.send(__method__)}.send(__method__)
  end

  def end
    ranges.max_by{|r| r.send(__method__)}.send(__method__)
  end

  def first(n=1)
    n == 1 ? ranges.first : ranges.first(n)
  end

  def last(n=1)
    n == 1 ? ranges.last : ranges.last(n)
  end

  private
  def select_ranges(&block)
    @ranges.select(&block)
  end
end