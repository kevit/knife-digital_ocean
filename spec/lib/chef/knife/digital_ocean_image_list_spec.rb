require 'spec_helper'

describe Chef::Knife::DigitalOceanImageList do

  subject { Chef::Knife::DigitalOceanImageList.new }

  let(:access_token) { ENV['DIGITALOCEAN_ACCESS_TOKEN'] }

  before :each do
    Chef::Knife::DigitalOceanImageList.load_deps
    Chef::Config['knife']['digital_ocean_access_token'] = access_token
    Chef::Config['knife']['public_images'] = true
    allow(subject).to receive(:puts)
  end

  describe "#run" do
    it "should validate the Digital Ocean config keys exist" do
      VCR.use_cassette('image') do
        expect(subject).to receive(:validate!)
        subject.run
      end
    end

    it "should output the column headers" do
      VCR.use_cassette('image') do
        expect(subject).to receive(:puts).with(/^ID\s+Distribution\s+Name\s+Slug\n/)
        subject.run
      end
    end

    it "should output a list of the available Digital Ocean Images" do
      VCR.use_cassette('image') do
        expect(subject).to receive(:puts).with(/\b7753256\s+Debian\s+test-snapshot\s+\n/)
        subject.run
      end
    end
  end
end
