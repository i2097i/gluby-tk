require 'rspec_helper'

describe String do
  it 'should convert strings back and forth between underscore -> humanize' do
    test_string = {:underscore => "test_string", :humanize => "TestString"}
    ["", "-", " ", ".", ",", "?", "'", "\"", ":", "/", ";", "\\", "_"].each do |char|
      2.times do |i|
        c = char * (i + 1)
        h = "#{c}#{test_string[:humanize]}#{c}"
        u = "#{c}#{test_string[:underscore]}#{c}"
        expect(h.underscore).to be == test_string[:underscore]
        expect(u.humanize).to be == test_string[:humanize]
        expect(u.underscore).to be == test_string[:underscore]
        # TODO: This is not fully functional
        # expect(h.humanize).to be == test_string[:humanize]
      end
    end
  end
end