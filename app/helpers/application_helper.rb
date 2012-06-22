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
        	urls << link_to("#{text}#{i+1}", damage.photo.url, :target => :blank)
        end if milestone.damages
        raw(urls.join(', '))
	end

	def documents_urls(milestone, text = nil)
		urls = []
		milestone.milestone_documents.each_with_index do |document,i| 
        	urls << link_to("#{text}#{i+1}", document.name.url, :target => :blank)
        end if milestone.milestone_documents
        raw(urls.join(', '))
	end

	def google_location_url(latitude,longitude,zoom=17)
		"https://maps.google.com/maps?&q=loc:#{latitude},#{longitude}&z=#{zoom}"
  	end

end
