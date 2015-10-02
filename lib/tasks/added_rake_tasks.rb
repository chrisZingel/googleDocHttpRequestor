require "HttpTest"
module HttpTest
  class HitServer
    include Rake::DSL if defined? Rake::DSL

    def install_tasks
      namespace:httptest do
        desc 'execute google list of urls'
        task :hitserver do |t, args|
          HttpTest::Google.process_records
        end
      end
    end
  end
 end

HttpTest::HitServer.new.install_tasks
