require 'spec_helper'

describe CompositeRange do
  it 'creates new object and fills ranges if passed' do
    subject.class.new.ranges.should eq([])
    subject.class.new((1..5)).ranges.should eq([(1..5)])
  end

  it 'creates new object and splits passed range to smaller ones by ranges, passed in :exclude option' do
    subject.class.new(1..20, exclude: 3..5).ranges.should eq([1..3, 5..20])
    subject.class.new(1..20, exclude: 3..20).ranges.should eq([1..3])
    subject.class.new(1..20, exclude: [3..5, 12..13, 16..19]).ranges.should eq([1..3, 5..12, 13..16, 19..20])
    subject.class.new(1..20, exclude: [3..5, 12..13, 16..20]).ranges.should eq([1..3, 5..12, 13..16])
  end

  describe '#[]' do
    before(:each) do
      @range = subject.class.new [(1..10), (13..21)]
    end

    it 'gets element by index' do
      @range[0].should eq(1..10)
      @range[1].should eq(13..21)
    end

    it 'gets nil if index not exists' do
      @range[2].should be_nil
    end

    it 'raises exception if not integer index provided' do
      ->{@range['key']}.should raise_error
    end
  end

  describe '#[]=' do
    before(:each) do
      @range = subject.class.new
    end

    it 'assigns element is it is CompositeRange or Range object' do
      @range[] = (1..10)
      @range[] = subject.class.new

      @range[0].should eq(1..10)
      @range[1].should eq(subject.class.new)
    end

    it 'raises error if element is not Range or CompositeRange' do
      ->{@range[] = 1}.should raise_error
    end
  end

  describe '#<<' do
    before(:each) do
      @range = subject.class.new
    end

    it 'pushes element to composite range if it is CompositeRange or Range object' do
      @range << (1..10)
      @range << subject.class.new
      @range[0].should eq(1..10)
      @range[1].should eq(subject.class.new)
    end

    it 'raises error if element is not Range or CompositeRange' do
      ->{@range << 1}.should raise_error
    end
  end

  describe '#each' do
    before(:each) do
      @range = subject.class.new([1..5, 8..10, 23..45])
      res = []
      @range.each{|r| res << r.begin + 5}
      res.should == [6, 13, 28]
    end

    it 'yields block for each element in @ranges' do

    end
  end

  describe '#cover?' do
    before(:each) do
      @range = subject.class.new([1..10, 12..45, -18..-3])
    end

    it 'returns true if one of @ranges covers passed object' do
      @range.cover?(10).should be_true
      @range.cover?(12).should be_true
      @range.cover?(15).should be_true
      @range.cover?(-17).should be_true
    end

    it 'returns false if passed object is not covered in any of @ranges' do
      @range.cover?(0).should be_false
      @range.cover?(11).should be_false
      @range.cover?(46).should be_false
      @range.cover?(-2).should be_false
    end
  end

  describe '#include?' do
    before(:each) do
      @range = subject.class.new([1..10, 12..45, -18..-3])
    end

    it 'returns true if one of @ranges includes passed object' do
      @range.include?(10).should be_true
      @range.include?(12).should be_true
      @range.include?(15).should be_true
      @range.include?(-17).should be_true
    end

    it 'returns false if passed object is not included in any of @ranges' do
      @range.include?(0).should be_false
      @range.include?(11).should be_false
      @range.include?(46).should be_false
      @range.include?(-2).should be_false
    end
  end

  describe '#begin' do
    before(:each) do
      @range = subject.class.new
    end

    it 'returns min object from all ranges start points' do
      @range << (1..10)
      @range << (3..12)
      @range << (21..85)
      @range.begin.should eq(1)
    end
  end

  describe '#end' do
    before(:each) do
      @range = subject.class.new
    end

    it 'returns min object from all ranges end points' do
      @range << (1..10)
      @range << (3..12)
      @range << (21..85)
      @range.end.should eq(85)
    end
  end

  describe '#first' do
    before(:each) do
      @range = subject.class.new
      @range << (1..10)
      @range << (3..12)
      @range << (21..85)
    end

    it 'returns first element if n is not specified' do
      @range.first.should eq(1..10)
    end

    it 'returns first n element if n is specified' do
      @range.first(2).should eq([1..10, 3..12])
    end
  end

  describe '#last' do
    before(:each) do
      @range = subject.class.new
      @range << (1..10)
      @range << (3..12)
      @range << (21..85)
    end

    it 'returns last element if n is not specified' do
      @range.last.should eq(21..85)
    end

    it 'returns last n element if n is specified' do
      @range.last(2).should eq([3..12, 21..85])
    end
  end

  describe '#==' do
    it 'composite ranges are == if @ranges are empty' do
      @range1 = subject.class.new
      @range2 = subject.class.new
      @range1.should == @range2
    end

    it 'composite ranges are == if @ranges are equal' do
      @range1 = subject.class.new([1..5, 7..10])
      @range2 = subject.class.new([1..5, 7..10])
      @range1.should == @range2
    end
  end

  describe '#eql?' do
    it 'composite ranges are eql? if @ranges are equal' do
      @range1 = subject.class.new([1..5, 7..10])
      @range2 = subject.class.new([1..5, 7..10])
      @range1.should == @range2
    end

    it 'ranges are not eql? if they are not of the same class' do
      @range1 = subject.class.new(1..5)
      @range2 = (1..5)
      @range1.should_not == @range2
    end
  end
end