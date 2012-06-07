class Parser
  class EDITransaction
    attr_accessor :data, :actions, :ship
    
    def initialize(data)
      @data = data

      raise 'File has wrong format' unless self.isa?



      plain = data.gsub(/\r\n/, '').split('~').map{|line| line.split('*')}

      isa = plain.find{|d| d.first.eql? "ISA"}
      self.ship = Time.parse("20" << isa[9] << isa[10])
      
      until plain.size.zero?
        plain = plain.drop_while{ |el| !el.first.eql?("ST") }
        plain.shift
        (self.actions||=[]) << plain.take_while{ |el| !el.first.eql?("ST") }
      end
    end

    def isa?
      data =~ /isa\*\d{2}\*/i
    end
    
  end

  attr_accessor :data, :spec
  attr_reader :errors
  
  def initialize(*args)
    @errors = []
    options = Hash[*args]
    unless options[:file_name].nil?
      path = options[:path] || default_files_path
      files_path = File.join(path, options[:file_name])      
    end
    self.data = EDITransaction.new(options[:data] || IO.read(files_path))
    raise 'Data is not defined.' if self.data.nil?
    self.spec = YAML::load(File.open(File.join(Rails.root, "lib", "parser", "cargo_spec.yml")))
    self.data.actions.each {|a| create_shipment(a) }
  rescue => e
    @errors << {
      :shipment_id => 'NA',
      :message => e.message,
      :full_message => e.message
    }
    puts self.errors.last[:full_message]
  end

  def default_files_path
    File.join(Rails.root, "lib", "parser")    
  end
  
  def create_shipment action
    b10 = action.find{|d| d.first.eql? "B10"}

    return if action.empty? || !b10
    
    shipment = Shipment.find_or_initialize_by_hawb b10[1]
    shipment.shipment_id ||= b10[2]
    shipment.ship ||= data.ship
    
    {"EY" => :origin, "DT" => :destination, "CN" => :consignee, "SH" => :shipper}.each_pair do |key, meth| # BT => OT
      n1 = action.find{|d| d[0] == "N1" && d[1] == key}
      shipment.send(:"#{meth}=", n1[2]) if n1 && shipment.send(meth).nil?
    end
    
    at7 = action.find{|d| d[0] == "AT7"}
    shipment.service_level = spec["AT7"][at7[1]]
    shipment.delivery = Time.parse(at7[5] + at7[6]) if at7[1] == 'D1'
    
    at8 = action.find{|d| d.first.eql? "AT8"}
    shipment.weight ||= at8[3]
    shipment.pieces ||= at8[5].to_i + at8[6].to_i
    unless shipment.save
      @errors << {
        :shipment_id => shipment.shipment_id,
        :message => shipment.errors.full_messages.join("; "),
        :full_message => "Shipment (#{shipment.shipment_id}) was not saved due to next errors: #{shipment.errors.full_messages.join("; ")}"
      }
      puts self.errors.last[:full_message]
    end
  end
end

