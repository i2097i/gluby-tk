require 'rspec_helper'

describe GlubyTK do
  TEST_PROJECT_DIR = "test_project"

  before :all do
    system "gluby new #{TEST_PROJECT_DIR}"
  end

  after :all do
    system "rm -rf #{TEST_PROJECT_DIR}/"
  end

  it 'should have a version number' do
    expect(GlubyTK::VERSION).to be_truthy
  end

  it 'should generate a new project directory' do
    expect(File.exist?(TEST_PROJECT_DIR)).to be true
  end

  it 'should generate all required sub-directories' do
    GlubyTK::Generator::DIRECTORIES.each {|dir|
      puts "\tChecking #{dir}..."
      expect(File.exist?("#{TEST_PROJECT_DIR}/#{dir}")).to be true
    }
  end

  it 'should generate all required files from templates' do
    GlubyTK::Generator::TEMPLATES.each {|template|
      puts "\tChecking #{template[:name]}..."
      expect(File.exist?("#{TEST_PROJECT_DIR}/#{template[:path]}/#{template[:name]}")).to be true
    }
  end

  # it 'should run the program properly' do
  #   success = system("cd #{TEST_PROJECT_DIR} && ruby #{Dir.pwd}/#{TEST_PROJECT_DIR}/main.rb &")
  #   sleep(10)
  #   system "pkill ruby"
  #   expect(success).to be == true
  # end

end