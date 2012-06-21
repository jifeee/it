module ApplicationHelper
	def locale_urls
		urls = []
		I18n::available_locales.map do |locale|
			options = {}
			options[:class] = 'active' if current_locale == locale
			options[:title] = t(:language, :locale => locale)
			urls << link_to(locale, language_path(locale), options)
		end
		raw(urls.join(' | '))
	end

	def damages_urls(milestone, text = nil)
		urls = []
		milestone.damages.each_with_index do |damage,i| 
        	urls << link_to("#{text}#{i+1}", damage.photo.url, 
        		:class => 'popupimage', 
        		:rel => "dmgg#{milestone.id}"
        	)
        end if milestone.damages
        raw(urls.join(', '))
	end

	def documents_urls(milestone, text = nil)
		urls = []
		milestone.milestone_documents.each_with_index do |document,i| 
			options = {}
			if ['.jpg'].include?(File.extname(document.name.current_path))
				options[:class] = 'popupimage'
				options[:rel] = "docg#{milestone.id}"
			else
				options[:target] = '_blank'
			end
        	urls << link_to("#{text}#{i+1}", document.name.url, options)
        end if milestone.milestone_documents
        raw(urls.join(', '))
	end

	def google_location_url(latitude,longitude,zoom=17)
		"https://maps.google.com/maps?&q=loc:#{latitude},#{longitude}&z=#{zoom}"
  	end

end
