require 'yaml'
require 'hashie'

class Settings
  def self.get
    @settings || @settings =  begin
                           ::Hashie::Mash.new(YAML.load(File.open( File.expand_path("../../../config/settings.yml", __FILE__))))
                             rescue ArgumentError => e
                               puts "Could not parse YAML: #{e.message}"
                             end
  end
end
