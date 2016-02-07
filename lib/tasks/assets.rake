namespace 'assets' do
  
  desc 'Creates non-digested versions of assets, needed by Ace'
  task 'non_digested_ace' => :environment do
    assets = Dir.glob(File.join(Rails.root, 'public', Rails.application.config.assets.prefix, '/ace/*'))
        
    regex = /(-{1}[a-z0-9]{32}){1}/
    assets.each do |file|
      next if File.directory?(file) || file !~ regex
  
      source = file.split('/')
      source.push(source.pop.gsub(regex, ''))
  
      non_digested = File.join(source)
      Rails.logger.info "Copying asset: #{file} to #{non_digested}"
      FileUtils.cp(file, non_digested)
    end
  end
  
end