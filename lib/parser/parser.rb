class Parser
  # processes one ST / SE segment
  def create_milestone
  end
  
  def parse data
    # ISA
    segment = data.shift until segment.first.eql? "ISA"
    ship = Time.parse(segment[8]+segment[9])
    
    # GS
    segment = data.shift until segment.first.eql? "GS"
    
  end
  
  def process_file(name)
    data = IO.read(File.join(Rails.root, "doc", name))
    parse(data.gsub(/\r\n/, '').split('~'))
  end
end


