require 'spec_helper'
require 'port_of_call/importer'

describe PortOfCall::Importer do
  with_model :BicycleType do
    table do |t|
      t.string :bicycle_type
    end
  end

  describe "#import!" do
    it "deletes old data and imports the new data" do

      BicycleType.create(id: 5, bicycle_type: "velocipede")

      described_class.new(BicycleType, "spec/fixtures/bicycles.csv").import!

      BicycleType.count.should == 4
      BicycleType.find(1).bicycle_type.should == "road bike"
      BicycleType.find(2).bicycle_type.should == "mountain bike"
      BicycleType.find(3).bicycle_type.should == "touring bike"
      BicycleType.find(4).bicycle_type.should == "beach cruiser"

      BicycleType.all.map(&:bicycle_type).should_not include("velocipede")
    end
  end
end
