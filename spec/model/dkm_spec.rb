require 'spec_helper'
describe DKM do
  it "should know the host to talk to" do
    DKM.host.should == "trk.kissmetrics.com"
  end
  it "should set and know the api_key" do
    DKM.init("DKM_KEY")
    DKM.api_key.should == "DKM_KEY"
  end
  it "should set and know the identiy know the id" do
    DKM.identify("BOB")
    DKM.identity.should == "BOB"

  end
  it "should raise an error if no key is provided" do
    DKM.init(nil)
    expect { DKM.record("") }.should raise_error(ArgumentError, "You must set an API key")
    expect { DKM.set("") }.should raise_error(ArgumentError, "You must set an API key")
    expect { DKM.alias("", "") }.should raise_error(ArgumentError, "You must set an API key")
  end

  it "should raise an error if no identity is set" do
    DKM.init("DKM_KEY")
    DKM.identify(nil)
    expect { DKM.record("") }.should raise_error(ArgumentError, "You must identify a user first")
    expect { DKM.set("") }.should raise_error(ArgumentError, "You must identify a user first")
    expect { DKM.alias("", "") }.should raise_error(ArgumentError, "You must identify a user first")
  end
  context "record" do
    before(:each) do
      @now = Time.now
      Time.stub!(:now).and_return(@now)
      DKM.init("DKM_KEY")
      DKM.identify("bob@aol.com")
      @delay = mock
      HTTParty.stub!(:delay).and_return(@delay)
    end

    def set_record_mock(action, args = {}, date = nil)
      @delay.should_receive(:get) do |url|
        uri = URI.parse(url)
        q = CGI.parse(uri.query)
        uri.host.should == DKM.host
        uri.path.should == "/e"
        q["_k"].first.should == "DKM_KEY"
        q["_p"].first.should == "bob@aol.com"
        q["_n"].first.should == action
        if date
          q["_d"].first.should == "1"
          q["_t"].first.should == date.to_i.to_s
        else
          q["_t"].first.should == @now.to_i.to_s
        end
        args.keys.each do |key|
          q[key.to_s].first.should == args[key].to_s
        end
      end
    end

    it "should allow you to record an event" do
      set_record_mock("Paid Us")
      DKM.record("Paid Us")
    end
    it "should allow you to record an event for a time in the past" do
      set_record_mock("Paid Us", {}, @now - 1.day)
      DKM.record("Paid Us", {"_t" => (@now - 1.day).to_i.to_s})
    end
    it "should allow you to record an event with additional properties" do
      set_record_mock("Paid Us", {"plan" => "Standard", "amount" => 25.00})
      DKM.record("Paid Us", {"plan" => "Standard", "amount" => 25.00})
    end
    it "should allow you to record an event with additional properties for a time in the past" do
      set_record_mock("Paid Us", {"plan" => "Standard", "amount" => 25.00}, @now - 1.day)
      DKM.record("Paid Us", {"plan" => "Standard", "amount" => 25.00, "_t" => (@now - 1.day).to_i.to_s})
    end
    it "should allow you to use symbols for keys on the additional properties" do
      set_record_mock("Paid Us", {"plan" => "Standard", "amount" => 25.00}, @now - 1.day)
      DKM.record("Paid Us", {:plan => "Standard", :amount => 25.00, :_t => (@now - 1.day).to_i.to_s})
    end
  end
  context "set" do
    before(:each) do
      @now = Time.now
      Time.stub!(:now).and_return(@now)
      DKM.init("DKM_KEY")
      DKM.identify("bob@aol.com")
      @delay = mock
      HTTParty.stub!(:delay).and_return(@delay)
    end

    def set_set_mock(args = {}, date = nil)
      @delay.should_receive(:get) do |url|
        uri = URI.parse(url)
        q = CGI.parse(uri.query)
        uri.host.should == DKM.host
        uri.path.should == "/s"
        q["_k"].first.should == "DKM_KEY"
        q["_p"].first.should == "bob@aol.com"

        if date
          q["_d"].first.should == "1"
          q["_t"].first.should == date.to_i.to_s
        else
          q["_t"].first.should == @now.to_i.to_s
        end
        args.keys.each do |key|
          q[key.to_s].first.should == args[key].to_s
        end
      end
    end

    it "should allow you to set a property on a profile" do
      set_set_mock({"plan" => "Standard"})
      DKM.set({"plan" => "Standard"})
    end
    it "should allow you to set multiple properties on a profile" do
      set_set_mock({"plan" => "Standard", "amount" => 25.00})
      DKM.set({"plan" => "Standard", "amount" => 25.00})
    end
    it "should allow you to set a property on a profile for a time in the past" do

      set_set_mock({"plan" => "Standard"}, @now - 1.day)
      DKM.set({"plan" => "Standard", "_t" => (@now - 1.day).to_i.to_s})
    end
    it "should allow you to set multiple properties on a profile for a time in the past" do
      set_set_mock({"plan" => "Standard", "amount" => 25.00}, @now - 1.day)
      DKM.set({"plan" => "Standard", "amount" => 25.00, "_t" => (@now - 1.day).to_i.to_s})
    end
    it "should allow you to use symbols for keys on  properties" do
      set_set_mock({"plan" => "Standard", "amount" => 25.00}, @now - 1.day)
      DKM.set({:plan => "Standard", :amount => 25.00, :_t => (@now - 1.day).to_i.to_s})
    end
  end

  it "should allow you to alias on identity to another" do

  end
  context "identify" do
    before(:each) do
      @now = Time.now
      Time.stub!(:now).and_return(@now)
      DKM.init("DKM_KEY")
      DKM.identify("bob@aol.com")
      @delay = mock
      HTTParty.stub!(:delay).and_return(@delay)
    end

    def set_identify_mock(old_name, new_name)
      @delay.should_receive(:get) do |url|
        uri = URI.parse(url)
        q = CGI.parse(uri.query)
        uri.host.should == DKM.host
        uri.path.should == "/a"
        q["_k"].first.should == "DKM_KEY"
        q["_p"].first.should == old_name
        q["_n"].first.should == new_name
      end
    end

    it "should allow you to alias a user" do
      set_identify_mock("sam@aol.com","will@aol.com")
      DKM.alias("sam@aol.com","will@aol.com")
    end
  end

end